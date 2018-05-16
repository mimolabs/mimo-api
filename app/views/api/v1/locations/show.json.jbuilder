# frozen_string_literal: true

json.id @location.id
json.location_name @location.location_name
json.unique_id @location.unique_id
json.slug @location.slug
json.created_at @location.created_at.to_i
json.updated_at @location.updated_at.to_i
json.location_address @location.location_address
json.street @location.street
json.postcode @location.postcode
json.town @location.town
json.country @location.country
json.phone1 @location.phone1
json.api_token @location.api_token
json.latitude @location.latitude
json.longitude @location.longitude
json.paid true # @location.paid
json.has_devices @location.has_devices
json.user_id @location.user_id
json.eu @location.eu
json.demo @location.demo
json.timezone @location.timezone

json.setup do
  json.splash       @location.splash_page_created
  json.integrations @location.integration_created
  json.campaigns    @location.campaign_created
end
