unless @shoes.blank?
  json.partial! partial: 'shoes/shoes', locals: { shoes: @shoes }
end