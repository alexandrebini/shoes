require 'sidekiq/web'

Shoes::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  root 'shoes#index'
end