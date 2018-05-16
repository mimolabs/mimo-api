json.senders do
  json.array! @senders do |sender|
    json.id sender.id.to_s
    json.created_at sender.created_at.to_i
    json.updated_at sender.updated_at.to_i
    json.user_id sender.user_id
    json.location_id sender.location_id
    json.sender_name sender.sender_name
    json.sender_type sender.sender_type
    json.from_name sender.from_name
    json.from_email sender.from_email
    json.from_sms sender.from_sms
    json.from_twitter sender.from_twitter
    json.reply_email sender.reply_email
    json.address sender.address
    json.town sender.town
    json.postcode sender.postcode
    json.country sender.country
    json.token sender.token
    json.is_validated sender.is_validated
  end
end

json._links do
  json.per params[:per]
  json.current_page @senders.current_page
  json.total_pages @senders.total_pages
  json.next_page @senders.next_page
  json.total_entries @senders.total_count
end
