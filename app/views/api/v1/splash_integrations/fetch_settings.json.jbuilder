# frozen_string_literal: true

json.array! @sites do |site|
  if site['_id'].present?
    # UniFI
    json.id             site['_id']
    json.name           site['name']
    json.description    site['desc']
  elsif site['zoneUUID']
    # Ruckus
    json.id             site['zoneUUID']
    json.name           site['zoneName']
  elsif site['network_id'].present?
    # CloudTrax
    json.id             site['id']
    json.name           site['name']
  elsif site['name'].present?
    # Meraki
    json.id             site['id']
    json.name           site['name']
  end
end
