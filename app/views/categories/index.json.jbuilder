json.array! @categories do |category|
  json.cache! category do
    json.name category.name
    json.slug category.slug
    json.brands category.brands.with_shoes.map(&:slug)
  end
end