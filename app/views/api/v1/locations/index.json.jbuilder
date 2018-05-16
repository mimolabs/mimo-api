# frozen_string_literal: true

json.locations do
  json.array! @locations do |location|
    json.id                 location.id
    json.location_name      location.location_name
    json.slug               location.slug
    json.location_address   location.location_address
    json.street             location.street
    json.phone1             location.phone1
    json.created_at         location.created_at.to_time.to_i
    json.updated_at         location.updated_at.to_time.to_i
    json.user_id            location.user_id
    json.lat                location.latitude
    json.lng                location.longitude
    # json.boxes_count        location.boxes_count.to_i
    json.api_token          location.api_token
  end
end

json._links do
  json.current_page         @locations.try(:current_page) || 1
  json.total_pages          @locations.try(:total_pages) || 0
  json.next_page            @locations.try(:next_page) || 0
  json.total_entries        @locations.total_count || 0
  json.size                 @size || 0
end
