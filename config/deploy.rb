set :application, 'shoes'
set :repo_url, 'git@github.com:alexandrebini/shoes.git'
set :branch, 'master'

set :deploy_to, '/home/shoes/www/'
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/cache}

set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  before :restart, :copy_server_files do
    on roles(:web) do
      execute "ln -sf #{ release_path }/config/server/production/nginx /usr/local/nginx/conf"
    end
  end

  after :finishing, 'deploy:cleanup'
end

namespace :seoserver do
  namespace :npm do
    after 'bundler:install', :install do
      on roles(:app) do
        execute <<-CMD
          cp #{ release_path }/config/server/production/*.yml #{ release_path }/current/
          mkdir -p #{ shared_path }/node_modules
          ln -s #{ shared_path }/node_modules #{ release_path }/seoserver/
          cd #{ release_path }/seoserver/ && npm install --production --silent
        CMD
      end
    end
  end

  task :stop do
    on roles(:app) do
      execute <<-CMD
        cd #{ release_path }/seoserver
        ./node_modules/.bin/forever stopall
      CMD
    end
  end

  task :start do
    on roles(:app) do
      execute <<-CMD
        cd #{ release_path }/seoserver
        ./node_modules/.bin/forever start node_modules/.bin/nodemon seoserver.js
      CMD
    end
  end

  before 'deploy:restart', :restart do
    invoke 'seoserver:stop' rescue nil
    invoke 'seoserver:start'
  end
end