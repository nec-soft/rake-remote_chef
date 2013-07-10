
set :remote_chef_path, '/usr'

namespace :chef do
  namespace :bootstrap do
  end

  desc 'Install chef.'
  remote_task :bootstrap do
    sudo "true && curl -L http://www.opscode.com/chef/install.sh | sudo bash"
  end
end
