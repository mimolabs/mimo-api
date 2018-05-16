json.timelines do
  json.array! @timelines do |timeline|
    json.id timeline.id.to_s
    json.created_at timeline.created_at.to_i
    json.updated_at timeline.updated_at.to_i
    json.location_id timeline.location_id
    json.person_id timeline.person_id
    json.event timeline.event
    json.meta timeline.meta
  end
end

json._links do
  json.per params[:per]
  json.current_page @timelines.current_page
  json.total_pages @timelines.total_pages
  json.next_page @timelines.next_page
  json.total_entries @timelines.total_count
end
