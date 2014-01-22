json.cache! @category do
  json.name @category.name
  json.meta_description @category.meta_description
  json.slug category_path(@category.slug)
end