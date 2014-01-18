namespace :db do
  desc 'populate...'
  task populate: :environment do
    FileUtils.rm_rf Dir.glob("#{ Rails.root }/public/system/*")
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
end