json.name @shoe.name
json.description @shoe.description
json.price @shoe.price
json.source_url @shoe.source_url
json.brand_name @shoe.brand_name
json.brand_logo @shoe.brand_logo
json.brand_url @shoe.brand_url

json.numerations do
  json.array! @shoe.numerations do |grid|
    json.number grid.number
  end
end

json.images do
  json.array! @shoe.photos do |photo|
    json.thumb_url  photo.url(:thumb)
    json.big_url photo.url(:big)
    json.alt @shoe.name
    json.main @shoe.is_main_photo?(photo)
  end
end