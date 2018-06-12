class SettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @update = REDIS.get('newVersion#beta')
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
    params.require(:settings).permit(:business_name, :from_email, :logo, :favicon, :code, :password, :docs_url, :terms_url, :intercom_id, :drift_id, :splash_twilio_user, :splash_twilio_pass, :splash_twitter_consumer_key, :splash_twitter_consumer_secret, :splash_google_client_id, :splash_google_client_secret, :splash_facebook_client_id, :splash_facebook_client_secret)
  end
end
