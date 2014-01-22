json.array! @brands.with_shoes do |brand|
  json.cache! brand do
    json.name brand.name
    json.slug brand_path(brand.slug)
  end
end