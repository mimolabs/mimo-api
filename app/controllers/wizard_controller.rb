class WizardController < ApplicationController
  before_action :authenticate_wizard, only: [:update, :complete]

  def start
    @logo = '/mimo-logo.svg'
    if params[:code]
      authenticate_wizard
      @domain = request.host || 'example.com'
      @settings = Settings.first_or_initialize
    else
      # REDIS.del('codeReq')
      @requested = REDIS.get('codeReq').present?
      @user = User.find_by(role: 0) unless @requested.present?
    end
  end

  def send_code
    @user = User.find_by(role: 0)
    @user.resend_code
  end

  def complete
    @domain = request.host || 'example.com'
    @settings = Settings.first_or_initialize
    @authorized = REDIS.del("wizardCode:#{@code}").to_i
  end

  def update
    @domain = request.host || 'example.com'
    @settings = Settings.first_or_initialize
    if @settings.update settings_params
      redirect_to wizard_complete_path(code: @code)
    else
      render 'start'
    end
  end

  private

  def authenticate_wizard
    @code = params[:code] || params[:settings] && params[:settings][:code]
    raise ActionController::RoutingError.new('Not Found') unless @code.present?

    val = REDIS.get "wizardCode:#{@code}"

    return if val.present?
    if action_name == 'complete'
      redirect_to ENV['MIMO_DASHBOARD_URL'] || new_user_session_path
    else
      raise ActionController::RoutingError.new('Not Found') unless val.present?
    end

    @settings = Settings.first_or_initialize
    raise ActionController::RoutingError.new('Not Found') unless @settings.new_record?
  end

  def settings_params
    params.require(:settings).permit(:business_name, :from_email, :logo, :favicon, :code, :password)
  end
end
