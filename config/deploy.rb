set :application, 'shoes'
set :repo_url, 'git@github.com:alexandrebini/shoes.git'
set :branch, 'master'

set :deploy_to, '/home/shoes/www/'
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :seoserver do
  namespace :npm do
    task :install do
      execute <<-CMD
        mkdir -p #{ shared_path }/node_modules &&
        ln -s #{ shared_path }/node_modules #{ release_path }/seoserver/ &&
        cd #{ release_path }/seoserver/ && npm install --production --silent
      CMD
    end
  end

  task :stop do
    execute <<-CMD
      cd #{ release_path }/seoserver &&
      ./node_modules/.bin/forever stopall
    CMD
  end

  task :start do
    execute <<-CMD
      cd #{ release_path }/seoserver &&
      ./node_modules/.bin/forever start node_modules/.bin/nodemon seoserver.js
    CMD
  end

  task :restart do
    stop
    start
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  before :restart, :copy_server_files do
    on roles(:web) do
      execute "ln -sf /home/shoes/www/current/config/server/nginx /usr/local/nginx/conf"
    end
  end
  after :finishing, 'deploy:cleanup'
end