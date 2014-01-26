json.cache! @brand do
  json.name @brand.name
  json.meta_description @brand.meta_description
  json.slug brand_path(@brand.slug)
end