class CreateSplashPages < ActiveRecord::Migration[5.2]
  def change
    create_table :splash_pages do |t|
      t.string   "unique_id",                limit: 64
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  'location_id'

      t.integer :registered_access_id
      t.integer :primary_access_id
      t.integer :access_period
      t.integer :max_all_session
      t.integer :container_transparency,      default: '1'
      t.integer :header_image_type,           default: 1
      t.integer :weight,                      default: 100
      t.integer :newsletter_type,             default: 0
      t.integer :access_restrict_mins,        default: 60
      t.integer :access_restrict_down,        default: 2048
      t.integer :access_restrict_up,          default: 1024
      t.integer :download_speed,              default: 2048
      t.integer :upload_speed,                default: 1024
      t.integer :session_timeout,             default: 60
      t.integer :idle_timeout,                default: 60
      t.integer :simultaneous_use,            default: 25
      t.integer :welcome_timeout
      # t.integer :vsg_port,                    default: 9443

      t.text :info
      t.text :info_two
      t.text :address
      t.text :splash_name
      t.text :description
      t.text :header_text
      t.text :error_message_text
      t.text :gdpr_email_field,                  default: 'I\'d like to receive updates by Email'
      t.text :gdpr_sms_field,                    default: 'I\'d like to receive updates by SMS'
      t.text :gdpr_contact_message,             default: 'Occasionally we\'d like to give you updates about products & services, promotions, special offers, news & events.'
      t.text :font_family,                      default: '\'Helvetica Neue\', Arial, Helvetica, sans-serif'
      t.text :fb_checkin_msg
      t.text :whitelisted
      t.text :blacklisted
      t.text :welcome_text
      t.text :no_login_message
      t.text :quota_message
      t.text :walled_gardens

      t.string :unique_id, limit: 24
      t.string :passwd_change_email, limit: 50
      t.string :logo_file_name, limit: 25
      t.string :background_image_name, limit: 25
      t.string :location_image_name, limit: 25
      t.string :header_image_name, limit: 25

      t.string :words_position,                   default: 'right', limit: 6
      t.string :logo_position,                    default: 'left', limit: 6
      t.string :container_float,                  default: 'center', limit: 6
      t.string :container_text_align,             default: 'center', limit: 6
      t.string :container_inner_width,            default: '100%', limit: 6
      t.string :container_inner_padding,          default: '20px', limit: 6
      t.string :container_inner_radius,           default: '4px', limit: 6
      t.string :bg_dimension,                     default: 'full', limit: 6
      t.string :header_colour,                    default: '#FFFFFF', limit: 22
      t.string :button_colour,                    default: '#FFFFFF', limit: 22
      t.string :button_radius,                    default: '4px', limit: 6
      t.string :button_border_colour,             default: '#000', limit: 22
      t.string :button_padding,                   default: '0px 16px', limit: 10
      t.string :button_height,                    default: '50px', limit: 6
      t.string :container_colour,                 default: '#FFFFFF', limit: 22
      t.string :container_width,                  default: '850px', limit: 6
      t.string :body_background_colour,           default: '#FFFFFF', limit: 22
      t.string :body_font_size,                   default: '14px', limit: 6
      t.string :heading_text_size,                default: '22px', limit: 6
      t.string :heading_text_colour,              default: '#000000', limit: 22
      t.string :heading_2_text_size,              default: '16px', limit: 6
      t.string :heading_2_text_colour,            default: '#000000', limit: 22
      t.string :heading_3_text_size,              default: '14px', limit: 6
      t.string :heading_3_text_colour,            default: '#000000', limit: 22
      t.string :body_text_colour,                 default: '#333333', limit: 22
      t.string :border_colour,                    default: '#CCCCCC', limit: 22
      t.string :btn_text,                         default: 'Login Now', limit: 25
      t.string :reg_btn_text,                     default: 'Register', limit: 25
      t.string :btn_font_size,                    default: '18px', limit: 6
      t.string :btn_font_colour,                  default: '#000000', limit: 22
      t.string :link_colour,                      default: '#2B68B6', limit: 22
      t.string :error_colour,                     default: '#ED561B', limit: 22
      t.string :email_button_colour,              default: 'rgb(255, 255, 255)', limit: 22
      t.string :email_button_border_colour,       default: 'rgb(204, 204, 204)', limit: 22
      t.string :email_btn_font_colour,            default: 'rgb(0, 0, 0)', limit: 22
      t.string :sms_button_colour,                default: 'rgb(239, 83, 80)', limit: 22
      t.string :sms_button_border_colour,         default: 'rgba(239, 83, 80, 0)', limit: 22
      t.string :sms_btn_font_colour,              default: 'rgb(255, 255, 255)', limit: 22
      t.string :voucher_button_colour,            default: 'rgb(255, 255, 255)', limit: 22
      t.string :voucher_button_border_colour,     default: 'rgb(204, 204, 204)', limit: 22
      t.string :voucher_btn_font_colour,          default: 'rgb(0, 0, 0)', limit: 22
      t.string :codes_button_colour,              default: 'rgb(255, 255, 255)', limit: 22
      t.string :codes_button_border_colour,       default: 'rgb(204, 204, 204)', limit: 22
      t.string :codes_btn_font_colour,            default: 'rgb(0, 0, 0)', limit: 22
      t.string :password_button_colour,           default: 'rgb(255, 255, 255)', limit: 22
      t.string :password_button_border_colour,    default: 'rgb(204, 204, 204)', limit: 22
      t.string :password_btn_font_colour,         default: 'rgb(0, 0, 0)', limit: 22
      t.string :access_restrict,                  default: 'none', limit: 10
      t.string :access_restrict_period,           default: 'daily', limit: 10
      t.string :available_start,                  default: '00:00', limit: 10
      t.string :available_end,                    default: '00:00', limit: 10
      t.string :input_padding,                    default: '10px 15px', limit: 10
      t.string :input_height,                     default: '40px', limit: 10
      t.string :input_border_colour,              default: '#d0d0d0', limit: 22
      t.string :input_border_width,               default: '1px', limit: 6
      t.string :input_border_radius,              default: '0px', limit: 6
      t.string :input_required_colour,            default: '#CCC', limit: 10
      t.string :input_required_size,              default: '10px', limit: 10
      t.string :input_background,                 default: '#FFFFFF', limit: 22
      t.string :input_text_colour,                default: '#3D3D3D', limit: 22
      t.string :input_max_width,                  default: '400px', limit: 6
      t.string :footer_text_colour,               default: '#CCC', limit: 22
      t.string :timezone,                         default: 'Europe/London', limit: 32
      t.string :popup_background_colour,          default: 'rgb(255,255,255)', limit: 22

      t.string :password, limit: 25
      t.string :fb_page_id, limit: 25
      t.string :fb_app_id, limit: 25
      t.string :fb_link, limit: 255
      t.string :success_url, limit: 255
      t.string :terms_url, limit: 255
      t.string :website, limit: 255
      t.string :external_css, limit: 255
      t.string :newsletter_api_token, limit: 255
      t.string :newsletter_list_id, limit: 32
      t.string :facebook_name, limit: 32
      t.string :google_name, limit: 32
      t.string :twitter_name, limit: 32

      t.string :g_api_key, limit: 10
      t.string :g_page_id, limit: 10
      t.string :splash_integration_id, limit: 24
      t.string :tw_handle, limit: 32
      t.string :vsg_host, limit: 255
      t.string :vsg_pass, limit: 50
      t.string :uamsecret, limit: 32
      t.string :default_password, limit: 32
      t.string :popup_image, limit: 10

      t.boolean:backup_sms,                       default: false
      t.boolean:backup_email,                     default: true
      t.boolean:backup_vouchers,                  default: false
      t.boolean:backup_password,                  default: false
      t.boolean:backup_quick_codes,               default: false
      t.boolean:active,                           default: true
      t.boolean:fb_checkin,                       default: false
      t.boolean:fb_msg,                           default: true
      t.boolean:fb_use_ps,                        default: true
      t.boolean:g_use_ps,                         default: true
      t.boolean:fb_login_on,                      default: false
      # t.boolean:splash_only,                      default: false
      t.boolean:secondary_access,                 default: false
      t.boolean:passwd_auto_gen,                  default: false
      # t.boolean:remove_registration_link,         default: false
      # t.boolean:override_form_code,               default: false
      # t.boolean:newsletter_active,                default: false
      # t.boolean:newsletter_checked,               default: true
      # t.boolean:newsletter_force_signup,          default: false
      t.boolean:skip_user_registration,           default: false
      t.boolean:g_redirect_to_page,               default: false
      t.boolean:g_login_on,                       default: false
      t.boolean:tw_send_tweet,                    default: false
      t.boolean:tw_login_on,                      default: false
      t.boolean:allow_registration,               default: false
      t.boolean:show_welcome,                     default: false
      t.boolean:fb_redirect_to_page,              default: false
      t.boolean:powered_by,                       default: true
      t.boolean:email_required,                   default: false
      t.boolean:newsletter_consent,               default: false
      t.boolean:vsg_enabled                     
      t.boolean:no_login                        
      t.boolean:hide_terms,                       default: false
      t.boolean:single_opt_in,                    default: false
      t.boolean:double_opt_in,                    default: true
      t.boolean:merge_fields,                     default: false
      t.boolean:debug,                            default: false
      t.boolean:vsg_async,                        default: true
      t.boolean:display_console,                  default: false
      t.boolean:bypass_popup_android,             default: false
      t.boolean:bypass_popup_ios,                 default: false
      t.boolean:popup_ad,                         default: false
      t.boolean:gdpr_form,                        default: true

      t.boolean :email_button_icon,                default: true
      t.boolean :codes_button_icon,                default: true
      t.boolean :password_button_icon,             default: true
      t.boolean :voucher_button_icon,              default: true
      t.boolean :sms_button_icon,                  default: false

      t.boolean:meraki_enabled                  
      t.boolean:unifi_enabled                   
      t.boolean:cloudtrax_enabled               
      t.boolean:button_shadow,                    default: true
      t.boolean:container_shadow,                 default: true

      t.text:available_days,                  array: true
      t.text:passwd_change_day,               array: true
      t.text:tags,                            array: true
      t.text:networks,                        array: true
    end

    add_index "splash_pages", ["location_id"], name: "index_splash_on_location_id", unique: false, using: :btree
  end
end
