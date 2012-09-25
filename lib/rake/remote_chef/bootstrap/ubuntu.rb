
set(:remote_chef_path) { ruby_path }
set :ruby_version, '1.9.3-p194'

namespace :chef do
  namespace :bootstrap do
    remote_task :update_package do
      # run [
        sudo 'apt-get -y update'#,
        sudo 'apt-get -y -qq -s -o Debug::NoLocking=true upgrade'
      # ].join(' && ')
    end

    remote_task :install_ruby_essential => :update_package do
      sudo 'apt-get -y install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool'
    end

    remote_task :install_ruby_build => :install_ruby_essential do
      run 'rm -rf ruby-build && git clone https://github.com/sstephenson/ruby-build.git'#,
      run 'cd ruby-build && sudo ./install.sh'
      sudo "mkdir -p #{ruby_path}"
    end

    remote_task :install_ruby19 => :install_ruby_build do
      sudo "ruby-build #{ruby_version} #{ruby_path}"
    end
  end

  desc 'Install chef.'
  remote_task :bootstrap => :'chef:bootstrap:install_ruby19' do
    sudo "#{ruby_path}/bin/gem install chef --no-ri --no-rdoc"
  end
end