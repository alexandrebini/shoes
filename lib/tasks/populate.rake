namespace :db do
  desc 'populate...'
  task populate: ['db:drop', 'db:create', 'db:migrate', 'db:seed'] do
    FileUtils.rm_rf("#{ Rails.root }/public/system")
  end
end