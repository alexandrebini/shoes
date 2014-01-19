set :stage, :production
set :branch, :try_files
role :app, %w{shoes}
role :web, %w{shoes}
role :db,  %w{shoes}