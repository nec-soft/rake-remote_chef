require 'rake/remote_task'
require "rake/remote_chef/version"

[
 ["Rake::RemoteChef",      :runlist, :run_list]
].each do |methods|
  receiver = methods.shift
  methods.each do |method|
    eval "def #{method} *args, &block; #{receiver}.#{method}(*args, &block);end"
  end
end

module Rake
  class RemoteChef

    def self.run_list role, runlist
      @runlist ||= {}
      @runlist[role] ||= []
      (@runlist[role] += runlist).uniq!
    end

    def self.run_list_for *roles
      roles.unshift(:default)
      roles.map {|r| @runlist[r] }.flatten.uniq.compact
    end


    def self.load options = {}
      options = {:config => options} if String === options
      order = [:bootstrap, :core]
      order += options.keys - order

      recipes = {
        :config => 'config/chef.rb',
        :bootstrap => 'bootstrap/ubuntu',
        :core => 'core'
      }.merge(options)

      order.each do |flavor|
        recipe = recipes[flavor]
        next if recipe.nil? or flavor == :config
        require "rake/remote_chef/#{recipe}"
      end

      set :ruby_path, '/opt/chef'
      set(:rsync_flags) {['-rlptDzP', '--exclude', '.git', '-e', "ssh #{ssh_flags.join(' ')}"]}

      Kernel.load recipes[:config]
      Kernel.load "config/chef_#{ENV['to']}.rb" if ENV['to']
    end

  end
end
