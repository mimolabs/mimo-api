# frozen_string_literal: true

json.form do
  json.body @form
end
json.splash do
  json.id @splash.unique_id
  json.splash_name @splash.splash_name
  # json.google_analytics_id]  = google_analytics_id
  json.registration @splash.primary_access_id == 8
  json.logo_file_name @splash.logo_file_name
  json.location_image_name @splash.location_image_name
  json.header_image_name @splash.header_image_name
  json.header_image_type @splash.header_image_type
  json.background_image_name @splash.background_image_name
  json.header_text @splash.header_text
  json.info @splash.info
  json.info_two @splash.info_two
  json.error_message_text @splash.error_message_text
  json.show_welcome @splash.show_welcome
  json.welcome_timeout @splash.welcome_timeout
  json.welcome_text @splash.welcome_text

  json.tw_handle @splash.tw_handle
  json.tw_handle @splash.tw_handle

  json.fb_checkin @splash.fb_checkin
  json.fb_page_id @splash.fb_page_id
  json.fb_redirect_to_page @splash.fb_redirect_to_page
  json.newsletter_consent @splash.newsletter_consent
  json.gdpr_email_field @splash.gdpr_email_field
  json.gdpr_sms_field @splash.gdpr_sms_field
  json.gdpr_contact_message @splash.gdpr_contact_message
  json.gdpr_form @splash.gdpr_form
  json.backup_email @splash.backup_email
  json.backup_vouchers @splash.backup_vouchers
  json.is_clickthrough @splash.is_clickthrough
  json.g_redirect_to_page @splash.g_redirect_to_page

  json.container_width @splash.container_width
  json.heading_text_colour @splash.heading_text_colour
  json.body_text_colour @splash.body_text_colour
  json.link_colour @splash.link_colour
  json.border_colour @splash.border_colour
  json.container_colour @splash.container_colour
  json.body_background_colour @splash.body_background_colour
  json.button_colour @splash.button_colour
  json.button_radius @splash.button_radius
  json.button_border_colour @splash.button_border_colour
  json.button_padding @splash.button_padding
  json.button_shadow @splash.button_shadow
  json.container_shadow @splash.container_shadow
  json.header_colour @splash.header_colour
  json.error_colour @splash.error_colour
  json.container_text_align @splash.container_text_align
  json.container_float @splash.container_float
  json.container_inner_width @splash.container_inner_width
  json.container_inner_padding @splash.container_inner_padding
  json.container_inner_radius @splash.container_inner_radius
  json.popup_ad @splash.popup_ad
  json.popup_image @splash.popup_image
  json.popup_background_colour @splash.popup_background_colour
  json.input_padding @splash.input_padding
  json.input_height @splash.input_height
  json.input_border_colour @splash.input_border_colour
  json.input_border_width @splash.input_border_width
  json.input_border_radius @splash.input_border_radius
  json.input_background @splash.input_background
  json.input_text_colour @splash.input_text_colour
  json.bg_dimension @splash.bg_dimension
  json.words_position @splash.words_position
  json.logo_position @splash.logo_position
  json.input_required_colour @splash.input_required_colour
  json.input_required_size @splash.input_required_size
  json.input_max_width @splash.input_max_width
  json.footer_text_colour @splash.footer_text_colour
  json.hide_terms @splash.hide_terms

  json.email_button_colour @splash.email_button_colour
  json.email_button_border_colour @splash.email_button_border_colour
  json.email_btn_font_colour @splash.email_btn_font_colour
  json.email_button_icon @splash.email_button_icon
  json.sms_button_colour @splash.sms_button_colour
  json.sms_button_border_colour @splash.sms_button_border_colour
  json.sms_btn_font_colour @splash.sms_btn_font_colour
  json.sms_button_icon @splash.sms_button_icon
  json.voucher_button_colour @splash.voucher_button_colour
  json.voucher_button_border_colour @splash.voucher_button_border_colour
  json.voucher_btn_font_colour @splash.voucher_btn_font_colour
  json.voucher_button_icon @splash.voucher_button_icon
  json.codes_button_colour @splash.codes_button_colour
  json.codes_button_border_colour @splash.codes_button_border_colour
  json.codes_btn_font_colour @splash.codes_btn_font_colour
  json.codes_button_icon @splash.codes_button_icon
  json.password_button_colour @splash.password_button_colour
  json.password_button_border_colour @splash.password_button_border_colour
  json.password_btn_font_colour @splash.password_btn_font_colour
  json.password_button_icon @splash.password_button_icon

  json.external_css @splash.external_css
  json.font_family @splash.font_family
  json.body_font_size @splash.body_font_size
  json.heading_text_size @splash.heading_text_size
  json.heading_2_text_size @splash.heading_2_text_size
  json.heading_2_text_colour @splash.heading_2_text_colour
  json.heading_3_text_size @splash.heading_3_text_size
  json.heading_3_text_colour @splash.heading_3_text_colour
  json.reg_btn_text @splash.reg_btn_text
  json.btn_text @splash.btn_text
  json.btn_font_size @splash.btn_font_size
  json.btn_font_colour @splash.btn_font_colour

  json.address @splash.address
  json.terms_url @splash.terms_url_full

  # json.powered_by @splash.powered_by
  # json.powered_by_name @splash.powered_by ? powered_by : nil

  json.twitter_name @splash.twitter_name
  json.google_name @splash.google_name
  json.pinterest_name @splash.pinterest_name
  json.facebook_name @splash.facebook_name
  json.linkedin_name @splash.linkedin_name
  json.instagram_name @splash.instagram_name
  # json.unified_code @splash.unified_login_code
  json.website @splash.website
end
