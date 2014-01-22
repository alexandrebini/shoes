json.array! @brands.with_shoes do |brand|
  json.cache! brand do
    json.name brand.name
    json.slug brand.slug
  end
end