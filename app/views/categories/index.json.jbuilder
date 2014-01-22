json.array! @categories do |category|
  json.cache! category do
    json.name category.name
    json.slug category_path(category.slug)
  end
end