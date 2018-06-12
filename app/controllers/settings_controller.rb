class SettingsController < ApplicationController
  # before_action :doorkeeper_authorize!

  def edit
    @settings = Settings.first
    @current_user = current_user
    authorize @settings
  end

  def update
    @settings = Settings.find(params[:id])
    if @settings.update settings_params
      @success = true
      redirect_to '/settings'
    else
      redirect_to '/settings'
    end
  end

  private

  def settings_params
    params.require(:settings).permit(:business_name, :from_email, :logo, :favicon, :code, :password, :docs_url, :terms_url, :intercom_id, :drift_id)
  end
end
