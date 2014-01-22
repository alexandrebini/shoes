json.array! @categories do |category|
  json.cache! category do
    json.name category.name
    json.slug category.slug
  end
end