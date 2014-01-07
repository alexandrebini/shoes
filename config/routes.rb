require 'sidekiq/web'

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

  class CategoryConstraint
    def self.matches?(request)
      Category.where(slug: request.params[:category]).exists?
    end
  end

  class BrandConstraint
    def self.matches?(request)
      Brand.where(slug: request.params[:brand]).exists?
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

  mount Sidekiq::Web, at: '/sidekiq'
  constraints FormatConstraint.new(:html) do
    root to: 'application#index'
    get '*path' => 'application#index'
  end

  constraints FormatConstraint.new(:json) do
    constraints PageConstraint.new do
      get '/(pg-:page)' => 'shoes#index', as: :shoes
      constraints BrandConstraint do
        get '/:brand/(pg-:page)' => 'brands#show', as: :brand
      end
      constraints CategoryConstraint.new do
        get '/:category(/pg-:page)' => 'categories#show', as: :category
        constraints BrandConstraint.new do
          get '/:category/:brand(/pg-:page)' => 'categories#brand', as: :category_brand
          get '/:category/:brand/:shoe' => 'shoes#show', as: :shoe
        end
      end
    end
  end
end