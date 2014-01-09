json.array! @brands do |brand|
  json.cache! brand do
    json.slug brand.slug
    json.name brand.name
  end
end