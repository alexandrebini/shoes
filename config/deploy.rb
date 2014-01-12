set :application, 'shoes'
set :repo_url, 'git@github.com:alexandrebini/shoes.git'
set :branch, 'master'

set :deploy_to, '/home/shoes/www/'
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :bundle_flags, '--deployment --quiet --binstubs'

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  after :finishing, 'deploy:cleanup'
end