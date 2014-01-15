module BrandsHelper
  def brands_slugs
    Brand.order(:slug).map(&:slug)
  end
end