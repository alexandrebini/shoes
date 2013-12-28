namespace :db do
  desc 'populate...'
  task populate: ['db:drop', 'db:create', 'db:migrate', 'db:seed']
end