set :application, 'Venshop_Duc'
set :repo_url, "git@gitlab.zigexn.vn:ducbm/Venshop_Duc.git"
set :rbenv_ruby, '2.3.1'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/home/vagrant/Venshop_Duc"
# set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :user, 'vagrant'

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5

namespace :deploy do

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && bundle exec passenger stop -p 8080" rescue nil
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && bundle exec passenger start -d -p 8080 -e production --user=vagrant"
    end
  end

  desc 'Restart application'
  task :restart do
    invoke "deploy:stop"
    invoke "deploy:start"
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

# desc 'Restart application'
# task :restart do
#   on roles(:app), in: :sequence, wait: 5 do
#     execute "service thin restart"  ## -> line you should add
#   end
# end

# after :publishing, :restart
