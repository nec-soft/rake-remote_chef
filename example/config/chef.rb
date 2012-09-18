
set :application,     "SetupServers"
set :user,            'ubuntu'

role :web,  "#{user}@host2.example.com"
role :db,   "#{user}@host1.example.com"

run_list :default,  [ 'recipe[java]' ]
run_list :web,      [ 'recipe[apache]' ]
run_list :db,       [ 'recipe[mysql]' ]
