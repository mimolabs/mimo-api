# frozen_string_literal: true

class Api::V1::SplashPagesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[index show create update destroy]
  before_action :clean_params, only: %i[update create]
  respond_to :json

  def index
    @splash_pages = SplashPage.where(location_id: @location.id)
    authorize @splash_pages
  end

  def show
    @splash_page = SplashPage.find_by(id: params[:id], location_id: @location.id)
  end

  def create
    @splash_page = SplashPage.new location_id: @location.id
    respond_to do |format|
      if @splash_page.update splash_params
        format.json do
          render template: 'api/v1/splash_pages/show.json.jbuilder',
                 status: 201
        end
      else
        @errors = @splash_page.errors.full_messages
        format.json do
          render template: 'api/v1/shared/index.json.jbuilder',
                 status: 422
        end
      end
    end
  end

  def update
    @splash_page = SplashPage.find_by(
      id: params[:id], location_id: @location.id
    )
    respond_to do |format|
      if @splash_page.update splash_params
        format.json do
          render template: 'api/v1/splash_pages/show.json.jbuilder',
                 status: 200
        end
      else
        @errors = @splash_page.errors.full_messages
        format.json do
          render template: 'api/v1/shared/index.json.jbuilder',
                 status: 422
        end
      end
    end
  end

  def destroy
    @splash_page = SplashPage.find_by(
      id: params[:id], location_id: @location.id
    )
    if @splash_page.destroy
      head :no_content
      return
    end

    @errors = @splash_page.errors.full_messages
    render template: 'api/v1/shared/index.json.jbuilder', status: 422
  end

  private

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end

  def splash_params
    params.require(:splash_page).permit(:success_url, :unique_id, :primary_access_id, :meraki_enabled, :unifi_enabled, :created_at, :splash_name, :active, :description, :passwd_change_day, :passwd_auto_gen, :passwd_change_email, :fb_use_ps, :fb_app_id, :fb_link, :fb_login_on, :g_login_on, :tw_login_on, :tw_handle, :g_api_key, :g_use_ps, :g_page_id, :g_redirect_to_page, :fb_redirect_to_page, :fb_checkin_msg, :fb_checkin, :newsletter_consent, :gdpr_email_field, :gdpr_sms_field, :gdpr_contact_message, :gdpr_form, :backup_sms, :backup_email, :backup_vouchers, :backup_quick_codes, :backup_password, :fb_page_id, :fb_msg, :access_restrict, :access_restrict_period, :access_restrict_mins, :access_restrict_down, :access_restrict_up, :whitelisted, :blacklisted, :available_days, :available_start, :available_end, :download_speed, :upload_speed, :powered_by, :session_timeout, :idle_timeout, :simultaneous_use, :allow_registration, :timezone, :password, :vsg_enabled, :vsg_async, :vsg_host, :vsg_pass, :email_required, :single_opt_in, :newsletter_type, :newsletter_api_token, :newsletter_list_id, :quota_message, :debug, :walled_gardens, :bypass_popup_ios, :bypass_popup_android, :tags, :terms_url, :logo_file_name, :background_image_name, :location_image_name, :header_image_name, :header_image_type, :header_text, :info, :info_two, :address, :error_message_text, :website, :facebook_name, :twitter_name, :google_name, :container_width, :container_text_align, :body_background_colour, :heading_text_colour, :body_text_colour, :border_colour, :link_colour, :container_colour, :button_colour, :button_radius, :button_border_colour, :button_padding, :button_shadow, :container_shadow, :header_colour, :error_colour, :container_transparency, :container_float, :container_inner_width, :container_inner_padding, :container_inner_radius, :bg_dimension, :words_position, :logo_position, :hide_terms, :font_family, :body_font_size, :heading_text_size, :heading_2_text_size, :heading_2_text_colour, :heading_3_text_size, :heading_3_text_colour, :btn_text, :reg_btn_text, :btn_font_size, :btn_font_colour, :input_required_colour, :input_required_size, :welcome_text, :welcome_timeout, :show_welcome, :external_css, :input_height, :input_padding, :input_border_colour, :input_border_radius, :input_border_width, :input_background, :input_text_colour, :input_max_width, :footer_text_colour, :popup_ad, :popup_image, :popup_background_colour, :email_button_colour, :email_button_border_colour, :email_btn_font_colour, :email_button_icon, :sms_button_colour, :sms_button_border_colour, :sms_btn_font_colour, :sms_button_icon, :voucher_button_colour, :voucher_button_border_colour, :voucher_btn_font_colour, :voucher_button_icon, :codes_button_colour, :codes_button_border_colour, :codes_btn_font_colour, :codes_button_icon, :password_button_colour, :password_button_border_colour, :password_btn_font_colour, :password_button_icon, :periodic_days, :userdays, :walled_gardens_array, :weight, :available_days, available_days: [])
  end

  def clean_params
    return unless params[:splash_page].present?
    options = JSON.parse params[:splash_page]
    params[:splash_page] = options if options
  rescue StandardError
  end
end
