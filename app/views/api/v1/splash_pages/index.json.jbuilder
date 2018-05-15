json.splash_pages do
  json.array! @splash_pages do |s|

    json.description s.description
    json.splash_name s.splash_name
    json.unique_id s.unique_id
    json.created_at s.created_at.to_i
    json.id s.id
    json.header_image_name s.header_image_name
    json.active s.active

    json.passwd_auto_gen s.passwd_auto_gen
    json.access_restrict s.access_restrict
    json.access_restrict_period s.access_restrict_period
    json.access_restrict_mins s.access_restrict_mins
    json.access_restrict_down s.access_restrict_down

    json.download_speed s.download_speed
    json.upload_speed s.upload_speed
    json.weight s.weight

    json.available_days s.available_days
    json.available_start s.available_start
    json.available_end s.available_end

    json.success_url s.success_url
    json.vsg_enabled s.vsg_enabled
    json.debug s.debug
    json.display_console s.display_console
    json.tags s.tags

    json.fb_login_on s.fb_login_on
    json.g_login_on s.g_login_on
    json.tw_login_on s.tw_login_on
    json.backup_sms s.backup_sms
    json.backup_email s.backup_email
    json.backup_vouchers s.backup_vouchers
    json.backup_password s.backup_password
    json.backup_quick_codes s.backup_quick_codes
  end
end

json.location do
  json.slug @location.slug
end

json.access_types do
  json.array! @access_types do |at|
    json.id at[:id]
    json.name at[:name]
  end
end

