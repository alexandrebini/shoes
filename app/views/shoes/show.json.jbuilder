json.name @shoe.name
json.description @shoe.description
json.price @shoe.price.split('.').first
json.cents @shoe.price.split('.').last
json.source_url @shoe.source_url
json.brand_name @shoe.brand.name
json.brand_logo @shoe.brand.logo
json.brand_url @shoe.brand.url

json.numerations do
  json.array! @shoe.numerations do |grid|
    json.number grid.number
  end
end

json.photos do
  json.array! @shoe.photos do |photo|
    json.thumb_url  photo.url(:thumb)
    json.big_url photo.url(:big)
    json.alt @shoe.name
    json.main @shoe.photo == photo
  end
end