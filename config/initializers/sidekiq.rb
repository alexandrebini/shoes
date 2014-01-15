require 'sidekiq'
require 'sidekiq/web'

unless Rails.env.development?
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [Settings.auth.name, Settings.auth.password]
  end
end