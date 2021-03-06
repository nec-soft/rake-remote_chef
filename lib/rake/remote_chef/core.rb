require 'yaml'
require 'erb'
require 'temp_dir'
require 'fileutils'
require 'json'
require 'deep_merge'

set :attributes_dir, './config/attributes'
set :solo_rb_template, File.dirname(__FILE__) + '/core/solo.rb.erb'

set :remote_chef_repo_path, '/tmp/chef-repo'
set :remote_file_cache_path, '/tmp/chef-cache'
set :remote_blob_dir, '/tmp/blob'

set :local_chef_repo, './chef-repo'
set :local_temp_dir,  TempDir.create
set :local_blob_dir,  './blob/'


class Rake::RemoteChef::Core

  class AttributesTemplate
    attr_reader :target_host

    def initialize(target_host)
      @target_host = target_host
    end

    def roles
      roles = []
      Rake::RemoteTask.roles.each do |k, v|
        roles << k if v.keys.include?(target_host)
      end
      roles
    end

    def all_roles
      Rake::RemoteTask.roles
    end

    def index_of_role role
      Rake::RemoteTask.roles[role].keys.index(target_host)
    end

    def load
      attributes = load_attributes_for(:default)
      roles.each do |role|
        attributes.deep_merge!(load_attributes_for(role) || {})
      end
      attributes.update('run_list' => Rake::RemoteChef.run_list_for(*roles)) unless attributes.has_key?('run_list')
      attributes
    end

    def load_attributes_for(role)
      role_file = "#{attributes_dir}/#{role.to_s}.yml.erb"
      if File.file?(role_file)
        open(role_file) do |io|
          YAML.load(ERB.new(io.read).result(binding))
        end
      else
        puts "attributes template not found at: #{role_file}"
        {}
      end
    end
  end

  def self.create_solo_rb path
    open(path, 'w') do |io|
      open(solo_rb_template) do |i|
        io.write ERB.new(i.read).result(binding)
      end
    end
  end
end


namespace :chef do

  task :create_temp_local_chef_repo do
    FileUtils.cp_r(local_chef_repo, local_temp_dir, :preserve => true)
    configs_dir = File.join(local_temp_dir, 'chef-repo', 'configs')
    FileUtils.mkdir_p(configs_dir)
    Rake::RemoteTask.all_hosts.each do |host|
      open(File.join(configs_dir, "#{host}.json"), 'w') do |io|
        io.write Rake::RemoteChef::Core::AttributesTemplate.new(host).load.to_json
      end
    end

    Rake::RemoteChef::Core.create_solo_rb File.join(configs_dir, 'solo.rb')
  end

  remote_task :update_repository => :create_temp_local_chef_repo do
    run "mkdir -p #{remote_chef_repo_path}"
    rsync File.join(local_temp_dir, 'chef-repo', ''), "#{target_host}:#{remote_chef_repo_path}"

    if File.directory?(local_blob_dir)
      run "mkdir -p #{remote_blob_dir}"
      rsync "#{local_blob_dir}", "#{target_host}:#{remote_blob_dir}"
    end
  end

  desc 'Execute chef-solo on remote.'
  remote_task :solo => :update_repository do
    sudo "#{remote_chef_path}/bin/chef-solo -c #{remote_chef_repo_path}/configs/solo.rb -j #{remote_chef_repo_path}/configs/#{target_host}.json"
  end

end
