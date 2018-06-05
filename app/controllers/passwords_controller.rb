class PasswordsController < Devise::PasswordsController
  before_action :settings

  def settings
    @settings = Settings.first_or_initialize
    @logo = @settings.logo.present? ? @settings.logo.url : '/mimo-logo.svg'
  end
end
