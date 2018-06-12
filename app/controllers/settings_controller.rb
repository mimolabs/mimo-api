class SettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @settings = Settings.first
    authorize @settings
  end

  def update
    @settings = Settings.first
    authorize @settings
    if @settings.update settings_params
      @success = true
      render 'edit'
    else
      redirect_to '/settings'
    end
  end

  private

  def settings_params
    params.require(:settings).permit(:business_name, :from_email, :logo, :favicon, :code, :password, :docs_url, :terms_url, :intercom_id, :drift_id)
  end
end
