Shoes::Application.routes.draw do
  class FormatConstraint
    attr_accessor :mime_type

    def initialize(format)
      @mime_type = Mime::Type.lookup_by_extension(format)
    end

    def matches?(request)
      [mime_type, '*/*'].include?(request.format)
    end
  end

  class PageConstraint
    def self.matches?(request)
      if request.params[:page]
        request.params[:page].match(/\d+/)
      else
        true
      end
    end
  end

  namespace :admin do
    mount Sidekiq::Web, at: '/sidekiq'
    root to: 'shoes#index'
    resources :shoes
  end

  constraints FormatConstraint.new(:html) do
    root to: 'application#index'
    get '*path' => 'application#index'
  end

  constraints FormatConstraint.new(:json) do
    get '/shoes/(pg-:page)/' => 'shoes#index', as: :shoes, constraints: PageConstraint
    get '/brands/' => 'brands#index', as: :brands
    get '/brands/:slug/' => 'brands#show', as: :brand
    get '/brands/:slug/shoes/(pg-:page)/' => 'brands#shoes', as: :brand_shoes, constraints: PageConstraint

    get '/categories/' => 'categories#index', as: :categories
    get '/categories/:slug/' => 'categories#show', as: :category
    get '/:category/:brand/:slug/' => 'shoes#show', as: :shoe
    get '/categories/:slug/shoes/(pg-:page)/' => 'categories#shoes', as: :category_shoes
    get '/categories/:slug/:brand/shoes/(pg-:page)/' => 'categories#brand_shoes', as: :category_brand_shoes
  end
end