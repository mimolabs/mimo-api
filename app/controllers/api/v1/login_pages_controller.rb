# frozen_string_literal: true

class Api::V1::LoginPagesController < Api::V1::BaseController
  before_action :auth_logins # , only: [:update, :show, :create, :show_welcome]

  ### The logins are still using JSONP
  after_action { |controller| handle_jsonp(controller) }

  respond_to :json

  def index; end

  def show
    @splash = find_splash
    # @short = params[:short]
    # @errors = @splash.splash_errors
    # if @errors
    #   @short = true
    # else
    @form = @splash.form_code(@client_mac, params[:uamip])
    render template: 'api/v1/logins/show.json.jbuilder', status: 200, callback: params[:callback]
  rescue CustomException => e
    @exception = e
    puts e.message
    puts 'xxxxxxxxxxxxxxxxxxxx'
    render template: 'api/v1/logins/errors.json.jbuilder', status: 200, callback: params[:callback]
  # rescue Exception => e
  #   raise e
  end

  def find_splash
    @splash = SplashPage.find_splash({
      client_mac:     @client_mac,
      ap_mac:         @ap_mac,
      tags:           params[:tags],
      uamip:          params[:uamip],
      splash_id:      params[:splash_id],
      location_id:    params[:location_id]
    })
  end

  private

  def set_resource; end

  def handle_jsonp(controller)
    return unless controller.params[:callback]
    controller.response['Content-Type'] = 'application/javascript'
    controller.response.body = "/**/#{controller.params[:callback]}(#{controller.response.body})"
  end

  def auth_logins
    if params[:request_uri].blank? || params[:apMac].blank?
      render status: 200, json: { message: "You're missing some params, please consult the docs.", error: true }.to_json, callback: params[:callback]
      return
    end

    @client_mac = params[:clientMac]
    @ap_mac     = Helpers.clean_mac params[:apMac]
    @box        = Box.where(mac_address: @ap_mac).select(:location_id, :mac_address).first

    return if @box.present?

    render status: 200, json: { message: 'Box not added', error: true }.to_json, callback: params[:callback]
  end
end
