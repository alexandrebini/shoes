namespace :init do
  desc 'cleanup system'
  task start: :environment do
    FileUtils.rm_rf("#{ Rails.root }/public/system")
    sh 'rake db:populate && rake crawler:start && rake shoes:status'
  end
end