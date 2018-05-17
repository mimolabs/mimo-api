# frozen_string_literal: true

json.boxes @boxes do |box|
  json.id box.id
  json.mac_address box.mac_address
  json.description box.description
  json.state box.state
end
