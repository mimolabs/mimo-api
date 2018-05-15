json.people do
  json.array! @people do |person|
    json.id person.id.to_s
    json.created_at person.created_at.to_time.to_i if person.created_at
    json.updated_at person.updated_at.to_time.to_i if person.updated_at
    json.last_seen person.last_seen.to_time.to_i if person.last_seen
    json.location_id person.location_id
    if person.email && person.consented
      json.email person.try(:email)
    end
    json.username person.username
    json.first_name person.first_name
    json.last_name person.last_name
    json.login_count person.login_count
    json.consented person.consented
  end
end

json._links do
  json.per params[:per]
  # json.current_page @people[:current_page]
  # json.total_pages @people[:total_pages]
  # json.next_page @people[:next_page]
  # json.total_entries @people[:total_count]
  # json.this_week @this_week
end
