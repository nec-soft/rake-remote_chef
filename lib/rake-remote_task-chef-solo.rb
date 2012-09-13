require 'rake/remote_task'
require "rake-remote_task-chef-solo/version"

[
 ["Rake::RemoteTask",      :runlist]
].each do |methods|
  receiver = methods.shift
  methods.each do |method|
    eval "def #{method} *args, &block; #{receiver}.#{method}(*args, &block);end"
  end
end

module Rake
  class RemoteTask

    def self.run_list role, runlist
      @runlist ||= {}
      @runlist[role] ||= []
      (@runlist[role] += runlist).uniq!
    end
    alias runlist run_list

    def self.runlist_for *roles
      roles.map {|r| @runlist[r] }.flatten.uniq.compact
    end

    module Chef
      module Solo

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
            require "rrtcs/#{recipe}"
          end

          set :ruby_path, '/opt/chef'
          set(:rsync_flags) {['-rlptDzP', '--exclude', '.git', '-e', "ssh #{ssh_flags.join(' ')}"]}

          Kernel.load recipes[:config]
          Kernel.load "config/chef_#{ENV['to']}.rb" if ENV['to']
        end

      end
    end
  end
end
