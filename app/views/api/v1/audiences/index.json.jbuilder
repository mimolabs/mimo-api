# frozen_string_literal: true

json.audiences do
  json.array! @audiences do |audience|
    json.id audience.id.to_s
    json.created_at audience.created_at.to_i
    json.updated_at audience.updated_at.to_i
    json.location_id audience.location_id
    json.name audience.name
    json.predicates audience.predicates
    json.predicate_type audience.predicate_type
  end
end

json._links do
  json.per params[:per]
  json.current_page @audiences.current_page
  json.total_pages @audiences.total_pages
  json.next_page @audiences.next_page
  json.total_entries @audiences.total_count
end
