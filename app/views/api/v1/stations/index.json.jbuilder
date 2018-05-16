# frozen_string_literal: true

json.stations @stations do |client|
  json.client_mac client.client_mac
  json.created_at client.created_at.to_i
  json.ssid client.ssid
end

# json.unique_aps @unique_aps

json._links do
  json.per params[:per]
  json.current_page @clients.try(:current_page) || 1
  json.total_pages @clients.try(:total_pages) || 0
  json.next_page @clients.try(:next_page)
  json.total_entries @clients.try(:total_count) || 0
end
