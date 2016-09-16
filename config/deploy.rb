# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'venshop_Duc'
set :repo_url, 'git@bitbucket.org:51300904/venshop.git'
set :rbenv_ruby, '2.3.1'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/vagrant/venshop_Duc'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

desc 'Restart application'
task :restart do
  on roles(:app), in: :sequence, wait: 5 do
    execute "service thin restart"  ## -> line you should add
  end
end

set :passenger_environment_variables, { :path => '/path-to-passenger/bin:$PATH' }
set :passenger_restart_command, '/path-to-passenger/bin/passenger-config restart-app'

set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
# after :publishing, :restart
