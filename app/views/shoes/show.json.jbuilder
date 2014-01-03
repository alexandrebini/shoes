json.name @shoe.name
json.description @shoe.description
json.price @shoe.price
json.source_url @shoe.source_url
json.numerations @shoe.numbers
json.photos @shoe.photos_urls

if @shoe.brand
  json.brand_name @shoe.brand.name
  json.brand_logo @shoe.brand.logo.path
  json.brand_url @shoe.brand.url
end