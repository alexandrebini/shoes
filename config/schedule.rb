every 1.day, at: '4:00 am' do
  command 'rm -rf /home/shoes/www/shared/public/cache/*'
  rake 'tmp:clear'
end

every 1.day, at: '4:30 am' do
  rake 'sitemap:refresh'
end