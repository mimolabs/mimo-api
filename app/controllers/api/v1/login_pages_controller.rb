# frozen_string_literal: true

class Api::V1::LoginPagesController < Api::V1::BaseController
  require 'errors'
  before_action :auth_logins

  ### The logins are still using JSONP
  after_action { |controller| handle_jsonp(controller) }

  respond_to :json

  def index; end

  def show
    @splash = find_splash
    @form = @splash.form_code(@client_mac, params[:uamip])
    render template: 'api/v1/logins/show.json.jbuilder', 
      status: 200, 
      callback: params[:callback]

  rescue Mimo::StandardError => @exception
    render template: 'api/v1/logins/errors.json.jbuilder', status: 200, callback: params[:callback]
  end

  def create
    @splash = SplashPage.find_by unique_id: params[:splash_id]
    resp = @splash.login(splash_attribtes)
    render :status=>200, :json=> resp, callback: params[:callback]
  rescue Mimo::StandardError => @exception
    render template: 'api/v1/logins/errors.json.jbuilder', status: 200
  end

  def find_splash
    opts = {
      client_mac:     @client_mac,
      ap_mac:         @box.mac_address,
      tags:           params[:tags],
      uamip:          params[:uamip],
      splash_id:      params[:splash_id],
      location_id:    @box.location_id
    }

    @splash = SplashPage.find_splash(opts)
  end

  private

  def splash_attributes
    return {
      mac:              @client_mac,
      ip:               params[:clientIp] || params[:client_ip],
      device:           params[:device],
      email:            params[:email],
      token:            params[:token],
      social_type:      params[:social_type],
      screen_name:      params[:screen_name],
      username:         params[:username],
      password:         params[:password],
      logincode:        params[:logincode],
      challenge:        params[:challenge],
      newsletter:       params[:newsletter],
      gid:              params[:gid],
      ap_mac:           params[:apMac] || params[:ap_mac],
      data:             params[:data]
    }
  end
  def set_resource; end

  def handle_jsonp(controller)
    return unless controller.params[:callback]
    controller.response['Content-Type'] = 'application/javascript'
    controller.response.body = "/**/#{controller.params[:callback]}(#{controller.response.body})"
  end

  def auth_logins
    if params[:request_uri].blank? || params[:apMac].blank?
      msg = I18n.t(:"logins.params_error", :default => "You're missing some params, please consult the docs.")
      render status: 200, json: { message: msg, error: true }.to_json, callback: params[:callback]
      return
    end

    @client_mac = params[:clientMac]
    @ap_mac     = Helpers.clean_mac params[:apMac]
    @box        = Box.where(mac_address: @ap_mac).select(:location_id, :mac_address).first

    return if @box.present?

    msg = I18n.t(:"logins.box_not_found", :default => "Box not added")
    render status: 200, json: { message: msg, error: true }.to_json, callback: params[:callback]
  end
end
