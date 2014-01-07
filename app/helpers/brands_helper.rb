module BrandsHelper
  def brands_permalinks
    Brand.all.map(&:permalink)
  end
end