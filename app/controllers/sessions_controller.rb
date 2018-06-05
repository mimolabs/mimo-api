class SessionsController < Devise::SessionsController
  before_action :settings

  def new
    settings = Settings.first
    if settings.blank?
      redirect_to wizard_start_path 
    else
      super
    end
  end

  def settings
    @settings = Settings.first_or_initialize
    @logo = @settings.logo.present? ? @settings.logo.url : '/mimo-logo.svg'
  end
end
