module SplashErrors
  def self.not_available
    raise Mimo::StandardError.new I18n.t(:"splash.not_available", :default => "Not available at this time")
  end

  def self.not_found
    raise Mimo::StandardError.new I18n.t(:"splash.not_found", :default => "No splash page found")
  end

  def self.not_clickthrough
    raise Mimo::StandardError.new I18n.t(:"splash.not_clickthrough", :default => "Clickthrough not allowed")
  end

  def self.no_integration
    raise Mimo::StandardError.new I18n.t(:"splash.integration_not_found", :default => "No integration found")
  end

  def self.login_unifi_client_error
    raise Mimo::StandardError.new I18n.t(:"splash.login_unifi_client_error", :default => "Could not login UniFi client")
  end

  def self.unifi_auth
    raise Mimo::StandardError.new I18n.t(:"splash.unifi_auth_error", :default => "Could not authorise UniFi")
  end

  def self.splash_incorrect_password
    raise Mimo::StandardError.new I18n.t(:"splash.invalid_password", :default => "Password incorrect")
  end

  def self.twilio_missing_creds
    raise Mimo::StandardError.new I18n.t(:"splash.twilio_missing_creds", :default => "Missing Twilio credentials")
  end

  def self.twilio_invalid_creds
    raise Mimo::StandardError.new I18n.t(:"splash.twilio_invalid_creds", :default => "Invalid Twilio credentials")
  end

  def self.twilio_invalid_number
    raise Mimo::StandardError.new I18n.t(:"splash.twilio_invalid_number", :default => "Invalid phone number")
  end
end
