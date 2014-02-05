module CategoriesHelper
  def categories_slugs
    Category.order(:slug).map(&:slug)
  end
end