# config valid for current version and patch releases of Capistrano
lock "~> 3.18.1"

set :repo_url, "git@github.com:thachbk/funny-movies.git"
set :user, 'ubuntu'

set :rvm, File.join('/home', fetch(:user), '.rvm', 'bin', 'rvm')
set :ruby_version, `cat .ruby-version`

# set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, false

set :linked_files, %w[config/database.yml public/robots.txt .env]
set :linked_dirs, %w[public/assets log certs]

append :linked_dirs, '.bundle'
set :bundle_binstubs, -> { shared_path.join('bin') }

set :rvm_type, :system
set :keep_releases, 5

set :ssh_options, keys: [File.join(ENV['HOME'], '.ssh', 'dropfoods', 'aws', 'new-dropfoods-ads-staging.pem'),
                         File.join(ENV['HOME'], '.ssh', 'dropfoods', 'aws', 'new-dropfoods-ads-production.pem')],
                  keepalive: true,
                  keepalive_interval: 30

set :sidekiq_config, -> { release_path.join('config', 'sidekiq.yml') }

set :nvm_type, :user # or :system|:user, depends on your nvm setup
set :nvm_node, 'v22.4.0'
set :nvm_map_bins, %w{node npm yarn}

# namespace :nvm do
#   task :load do
#     on roles(:app) do
#       execute :echo, "Loading NVM"
#       execute "source ~/.nvm/nvm.sh && nvm install #{fetch(:nvm_node)} && nvm use #{fetch(:nvm_node)} && yarn install"
#       # yarn install
#       # export PATH=$(dirname $(nvm which current)):$PATH
#     end
#   end
# end
# before 'deploy:assets:precompile', 'nvm:load'

# namespace :node do
#   desc 'Set Node version'
#   task :set_version do
#     on roles(:app) do
#       within release_path do
#         execute :bash, '-lc', "'nvm install 18.20.3; nvm use v18.20.3'"
#       end
#     end
#   end
# end
# before 'deploy:assets:precompile', 'node:set_version'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Runs rake db:seed'
  task seed: [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  after 'deploy:migrate', 'deploy:seed'
end


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
