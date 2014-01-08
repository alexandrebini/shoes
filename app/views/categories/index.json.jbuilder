json.array! @categories do |category|
  json.cache! category do
    json.slug category_path(category.slug)
    json.name category.name
  end
end