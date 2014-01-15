json.array! @brands.with_shoes do |brand|
  json.cache! brand do
    json.slug brand.slug
    json.name brand.name
  end
end