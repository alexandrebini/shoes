if @shoe
  json.name @shoe.name
  json.description @shoe.description
  json.price @shoe.price[:int]
  json.cents @shoe.price[:cents]
  json.slug shoe_path(@shoe.category, @shoe.brand, @shoe.slug)
  json.source_url @shoe.source_url

  json.brand do |json|
    json.name @shoe.brand.name
    json.slug @shoe.brand.slug
    json.logo do |json|
      json.url @shoe.brand.logo.url(:thumb)
      json.height @shoe.brand.logo.height(:thumb)
      json.width @shoe.brand.logo.width(:thumb)
    end
  end

  json.numerations do
    json.array! @shoe.numerations do |grid|
      json.number grid.number
    end
  end

  json.photos do
    json.array! @shoe.photos do |photo|
      json.thumb_url photo.url(:thumb)
      json.big_url photo.url(:big)
      json.alt @shoe.name
      json.main @shoe.photo == photo
    end
  end
end