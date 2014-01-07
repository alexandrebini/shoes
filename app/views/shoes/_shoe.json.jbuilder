json.cache! shoe do
  json.slug shoe_path(shoe.category, shoe.brand, shoe.slug)
  json.name shoe.name
  json.thumb do |json|
    json.url shoe.photo.url(:thumb)
    json.height shoe.photo.height(:thumb)
    json.width shoe.photo.width(:thumb)
  end
  json.long do |json|
    json.url shoe.photo.url(:long)
    json.height shoe.photo.height(:long)
    json.width shoe.photo.width(:long)
  end
  json.wide do |json|
    json.url shoe.photo.url(:wide)
    json.height shoe.photo.height(:wide)
    json.width shoe.photo.width(:wide)
  end
end