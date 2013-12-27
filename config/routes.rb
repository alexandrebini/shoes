require 'sidekiq/web'

Shoes::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
end