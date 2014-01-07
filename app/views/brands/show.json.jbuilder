json.partial! 'brands/brand', brand: @brand
json.shoes do
  json.partial! 'shoes/shoes', shoes: @shoes
end