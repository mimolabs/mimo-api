json.splash_page do
  json.id @splash_page.id.to_s
  json.location_id @splash_page.location_id
  json.success_url @splash_page.success_url
  json.unique_id @splash_page.unique_id
  json.primary_access_id @splash_page.primary_access_id
  json.meraki_enabled @splash_page.meraki_enabled
  json.unifi_enabled @splash_page.unifi_enabled

  json.created_at @splash_page.created_at.to_i
  json.splash_name @splash_page.splash_name
  json.active @splash_page.active
  json.description @splash_page.description
  json.passwd_change_day @splash_page.passwd_change_day
  json.passwd_auto_gen @splash_page.passwd_auto_gen
  json.passwd_change_email @splash_page.passwd_change_email
  json.fb_use_ps @splash_page.fb_use_ps
  json.fb_app_id @splash_page.fb_app_id
  json.fb_link @splash_page.fb_link
  json.fb_login_on @splash_page.fb_login_on
  json.g_login_on @splash_page.g_login_on
  json.tw_login_on @splash_page.tw_login_on
  json.tw_handle @splash_page.tw_handle
  json.g_api_key @splash_page.g_api_key
  json.g_use_ps @splash_page.g_use_ps
  json.g_page_id @splash_page.g_page_id
  json.g_redirect_to_page @splash_page.g_redirect_to_page
  json.fb_redirect_to_page @splash_page.fb_redirect_to_page
  json.fb_checkin_msg @splash_page.fb_checkin_msg
  json.fb_checkin @splash_page.fb_checkin
  json.newsletter_consent @splash_page.newsletter_consent

  json.gdpr_email_field @splash_page.gdpr_email_field
  json.gdpr_sms_field @splash_page.gdpr_sms_field
  json.gdpr_contact_message @splash_page.gdpr_contact_message
  json.gdpr_form @splash_page.gdpr_form
  json.backup_sms @splash_page.backup_sms
  json.backup_email @splash_page.backup_email
  json.backup_vouchers @splash_page.backup_vouchers
  json.backup_quick_codes @splash_page.backup_quick_codes
  json.backup_password @splash_page.backup_password
  # json.is_clickthrough @splash_page.is_clickthrough
  json.fb_page_id @splash_page.fb_page_id
  json.fb_msg @splash_page.fb_msg
  json.access_restrict @splash_page.access_restrict
  json.access_restrict_period @splash_page.access_restrict_period
  json.access_restrict_mins @splash_page.access_restrict_mins
  json.access_restrict_down @splash_page.access_restrict_down
  json.access_restrict_up @splash_page.access_restrict_up
  json.whitelisted @splash_page.whitelisted
  json.blacklisted @splash_page.blacklisted
  json.available_days @splash_page.available_days
  json.available_start @splash_page.available_start
  json.available_end @splash_page.available_end
  json.download_speed @splash_page.download_speed
  json.upload_speed @splash_page.upload_speed
  json.powered_by @splash_page.powered_by
  json.session_timeout @splash_page.session_timeout
  json.idle_timeout @splash_page.idle_timeout
  json.simultaneous_use @splash_page.simultaneous_use
  json.allow_registration @splash_page.allow_registration
  json.timezone @splash_page.timezone
  json.password @splash_page.password
  json.weight @splash_page.weight
  json.vsg_enabled @splash_page.vsg_enabled
  json.vsg_async @splash_page.vsg_async
  json.vsg_host @splash_page.vsg_host
  json.vsg_pass @splash_page.vsg_pass
  # json.vsg_port @splash_page.vsg_port
  json.email_required @splash_page.email_required
  json.single_opt_in @splash_page.single_opt_in
  json.newsletter_type @splash_page.newsletter_type
  json.newsletter_api_token @splash_page.newsletter_api_token
  json.newsletter_list_id @splash_page.newsletter_list_id
  # json.paid_user @current_user.paid_plan?
  json.quota_message @splash_page.quota_message
  json.debug @splash_page.debug
  json.walled_gardens @splash_page.walled_gardens
  json.bypass_popup_ios @splash_page.bypass_popup_ios
  json.bypass_popup_android @splash_page.bypass_popup_android
  json.tags @splash_page.tags

  json.terms_url @splash_page.terms_url
  json.logo_file_name @splash_page.logo_file_name
  json.background_image_name @splash_page.background_image_name
  json.location_image_name @splash_page.location_image_name
  json.header_image_name @splash_page.header_image_name
  json.header_image_type @splash_page.header_image_type

  json.header_text @splash_page.header_text
  json.info @splash_page.info
  json.info_two @splash_page.info_two
  json.address @splash_page.address
  json.error_message_text @splash_page.error_message_text

  json.website @splash_page.website
  json.facebook_name @splash_page.facebook_name
  json.twitter_name @splash_page.twitter_name
  json.google_name @splash_page.google_name

  json.fb_login_on @splash_page.fb_login_on
  json.g_login_on @splash_page.g_login_on
  json.tw_login_on @splash_page.tw_login_on

  json.backup_email @splash_page.backup_email
  json.backup_vouchers @splash_page.backup_vouchers

  json.container_width @splash_page.container_width
  json.container_text_align @splash_page.container_text_align
  json.body_background_colour @splash_page.body_background_colour
  json.heading_text_colour @splash_page.heading_text_colour
  json.body_text_colour @splash_page.body_text_colour
  json.border_colour @splash_page.border_colour
  json.link_colour @splash_page.link_colour
  json.container_colour @splash_page.container_colour
  json.button_colour @splash_page.button_colour
  json.button_radius @splash_page.button_radius
  json.button_border_colour @splash_page.button_border_colour
  json.button_padding @splash_page.button_padding
  json.button_shadow @splash_page.button_shadow
  json.container_shadow @splash_page.container_shadow
  json.header_colour @splash_page.header_colour
  json.error_colour @splash_page.error_colour
  json.container_transparency @splash_page.container_transparency
  json.container_float @splash_page.container_float
  json.container_inner_width @splash_page.container_inner_width
  json.container_inner_padding @splash_page.container_inner_padding
  json.container_inner_radius @splash_page.container_inner_radius
  json.bg_dimension @splash_page.bg_dimension
  json.words_position @splash_page.words_position
  json.logo_position @splash_page.logo_position
  json.hide_terms @splash_page.hide_terms
  json.font_family @splash_page.font_family
  json.body_font_size @splash_page.body_font_size
  json.heading_text_size @splash_page.heading_text_size
  json.heading_2_text_size @splash_page.heading_2_text_size
  json.heading_2_text_colour @splash_page.heading_2_text_colour
  json.heading_3_text_size @splash_page.heading_3_text_size
  json.heading_3_text_colour @splash_page.heading_3_text_colour
  json.btn_text @splash_page.btn_text
  json.reg_btn_text @splash_page.reg_btn_text
  json.btn_font_size @splash_page.btn_font_size
  json.btn_font_colour @splash_page.btn_font_colour
  json.input_required_colour @splash_page.input_required_colour
  json.input_required_size @splash_page.input_required_size
  json.welcome_text @splash_page.welcome_text
  json.welcome_timeout @splash_page.welcome_timeout
  json.show_welcome @splash_page.show_welcome
  json.external_css @splash_page.external_css
  json.input_height @splash_page.input_height
  json.input_padding @splash_page.input_padding
  json.input_border_colour @splash_page.input_border_colour
  json.input_border_radius @splash_page.input_border_radius
  json.input_border_width @splash_page.input_border_width
  json.input_background @splash_page.input_background
  json.input_text_colour @splash_page.input_text_colour
  json.input_max_width @splash_page.input_max_width
  json.footer_text_colour @splash_page.footer_text_colour
  json.popup_ad @splash_page.popup_ad
  json.popup_image @splash_page.popup_image
  json.popup_background_colour @splash_page.popup_background_colour
  json.email_button_colour @splash_page.email_button_colour
  json.email_button_border_colour @splash_page.email_button_border_colour
  json.email_btn_font_colour @splash_page.email_btn_font_colour
  json.email_button_icon @splash_page.email_button_icon
  json.sms_button_colour @splash_page.sms_button_colour
  json.sms_button_border_colour @splash_page.sms_button_border_colour
  json.sms_btn_font_colour @splash_page.sms_btn_font_colour
  json.sms_button_icon @splash_page.sms_button_icon
  json.voucher_button_colour @splash_page.voucher_button_colour
  json.voucher_button_border_colour @splash_page.voucher_button_border_colour
  json.voucher_btn_font_colour @splash_page.voucher_btn_font_colour
  json.voucher_button_icon @splash_page.voucher_button_icon
  json.codes_button_colour @splash_page.codes_button_colour
  json.codes_button_border_colour @splash_page.codes_button_border_colour
  json.codes_btn_font_colour @splash_page.codes_btn_font_colour
  json.codes_button_icon @splash_page.codes_button_icon
  json.password_button_colour @splash_page.password_button_colour
  json.password_button_border_colour @splash_page.password_button_border_colour
  json.password_btn_font_colour @splash_page.password_btn_font_colour
  json.password_button_icon @splash_page.password_button_icon
end
