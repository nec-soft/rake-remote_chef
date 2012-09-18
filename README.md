# Rake::RemoteChef

Rake::RemoteChef can run chef-solo on remote host using local Rake.

## Installation

Add this line to your application's Gemfile:

    gem 'rake-remote_chef'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rake-remote_chef

## Usage

    $ rake chef:bootstrap   # first time only. (Install chef-solo on remote host.)
    $ rake chef:solo

## Setup

Create a config file, usually in 'config/chef.rb'

    set :application,     "SetupServers"
    set :user,            'ubuntu'

    # Setup roles for Hosts
    # 'role' means Rake::RemoteTask role. (not Chef.)
    role :role1, "#{user}@host1.example.com"
    role :role2, "#{user}@host2.example.com"

    # Setup run_list for roles
    run_list :role1, ['recipe[apache]', 'recipe[monit]']
    run_list :role2, ['recipe[ruby]', 'recipe[thin]', 'recipe[my_app]']

Create attributes file, usually in 'config/attributes/default.yml.erb'
and 'config/attributes/#{role_name}.yml.erb'.

default.yml.erb is used from all roles for default attributes.

    host: <%= target_host.split('@').last %>
    env:
      http_proxy: 'http://proxy.host:port'
      https_proxy: 'https://proxy.host:port'
      no_proxy: '192.168.*.*'

    nats_server:
      host: <%= all_roles[:nats_server].keys.first.split('@').last %>
      port: 4222
      user: nats
      password: nats

'config/attributes/#{role_name}.yml.erb' contains role specific attributes.

    router:
      index: <%= index_of_role(:router) %>
    apache:
      dir: '/etc/apache2'
      log_dir: '/var/log/apache2'

Add the folloing to your Rakefile:

    require 'rake/remote_chef'
    Rake::RemoteChef.load

### Set up _Chef Repository_ 

usually in './chef-repo' directory.

    chef-repo/
        cookbooks/
        data_bags/
        roles/

chef-repo directory contains cookbooks, data_bags and roles direcotry.

### Bootstrap for chef-solo on remote host

Run `rake chef:bootstrap` install chef to your remote host.

### Execute chef-solo

Run `rake chef:solo` execute chef-solo on your remote host.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
