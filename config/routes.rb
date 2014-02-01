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
    resources :brands, except: :show
    resources :categories, except: :show
    resources :colors, except: :show
    resources :palettes, except: :show
    resources :shoes, except: :show
  end

  constraints FormatConstraint.new(:html) do
    root to: 'application#index'
    get '*path' => 'application#index'
    # routes above are just mocks
    get '/(pg-:page)/' => 'application#index', as: :html_shoes, constraints: PageConstraint
    get "/:slug/(pg-:page)/" => 'application#index', as: :html_brand_shoes, constraints: PageConstraint
    get "/:slug/(pg-:page)/" => 'application#index', as: :html_category_shoes, constraints: PageConstraint
    get "/:slug/:brand/(pg-:page)/" => 'application#index', as: :html_category_brand_shoes, constraints: PageConstraint
    get '/:category/:brand/:slug/' => 'application#index', as: :html_shoe
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
    get '/:slug/:brand/shoes/(pg-:page)/' => 'categories#brand_shoes', as: :category_brand_shoes
  end
end