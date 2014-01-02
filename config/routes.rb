require 'sidekiq/web'

Shoes::Application.routes.draw do
  class FormatTest
    attr_accessor :mime_type

    def initialize(format)
      @mime_type = Mime::Type.lookup_by_extension(format)
    end

    def matches?(request)
      [mime_type, '*/*'].include?(request.format)
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'
  constraints FormatTest.new(:html) do
    root to: 'application#index'
    get '*path' => 'application#index'
  end

  constraints FormatTest.new(:json) do
    get '/shoes' => 'shoes#index', as: :shoes
    get '/shoes/:slug' => 'shoes#shoe', as: :shoe
  end
end