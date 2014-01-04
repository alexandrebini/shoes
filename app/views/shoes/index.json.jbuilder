json.child! do |json|
  json.perPage params[:per_page].to_i
  json.page @shoes.current_page
  json.totalPages @shoes.total_pages
end

json.child! do |json|
  json.array! @shoes do |shoe|
    json.slug shoe.slug
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
end