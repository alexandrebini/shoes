json.child! do |json|
  json.perPage params[:per_page].to_i
  json.page shoes.current_page
  json.totalPages shoes.total_pages
end

json.child! do |json|
  json.partial! partial: 'shoes/shoe', collection: shoes, as: :shoe
end