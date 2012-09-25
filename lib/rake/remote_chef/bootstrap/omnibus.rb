
set :remote_chef_path, '/usr'

namespace :chef do
  namespace :bootstrap do
  desc 'Install chef.'
  remote_task :bootstrap do
    sudo "curl -L http://www.opscode.com/chef/install.sh | bash"
  end
end
