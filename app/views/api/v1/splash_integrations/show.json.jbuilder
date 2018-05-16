json.id @splash_integration.id.to_s
json.created_at @splash_integration.created_at
json.updated_at @splash_integration.updated_at
json.host @splash_integration.host
json.username @splash_integration.username
json.password @splash_integration.password
json.new_record @splash_integration.new_record? if @splash_integration.new_record?
json.type @splash_integration.type
json.active @splash_integration.active
json.ssid @splash_integration.metadata[:ssid]
