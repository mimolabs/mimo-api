json.sms do
  json.array! @sms do |sms|
    json.id sms.id.to_s
    json.created_at sms.created_at.to_i
    json.updated_at sms.updated_at.to_i
    json.location_id sms.location_id
    json.number sms.number
  end
end

json._links do
  json.per params[:per]
  json.current_page @sms.current_page
  json.total_pages @sms.total_pages
  json.next_page @sms.next_page
  json.total_entries @sms.total_count
end
