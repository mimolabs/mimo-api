class WizardController < ApplicationController
  # before_action :authenticate_user!, except: [:show]
  before_action :authenticate_wizard

  def start
    @domain = request.host || 'example.com'
    @settings = Settings.first_or_initialize
  end

  def update
    @domain = request.host || 'example.com'
    @settings = Settings.first_or_initialize
    if @settings.update settings_params
      redirect_to wizard_start_path
    else
      render 'start'
    end
  end

  private

  def authenticate_wizard
    # code = params[:code]
    # raise ActionController::RoutingError.new('Not Found') unless code.present?

    # val = REDIS.get "wizardCode:#{code}"
    # raise ActionController::RoutingError.new('Not Found') unless val.present?
  end

  def settings_params
    params.require(:settings).permit(:business_name, :from_email, :logo, :favicon)
  end
end
