json.locations do
  json.array! @locations do |location|
    json.id location.id
  end
end
