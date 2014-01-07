module BrandsHelper
  def brands_slugs
    Brand.order(:slug).all.map(&:slug)
  end
end