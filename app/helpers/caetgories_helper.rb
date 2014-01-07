module CategoriesHelper
  def categories_routes
    Array.new.tap do |permalinks|
      Category.all.each do |category|

      end
      Brand.all.map(&:permalink)
    end
  end
end