module SplashErrors
  def self.not_available
    raise Mimo::StandardError.new I18n.t(:"splash.not_available", :default => "Not available at this time")
  end

  def self.not_found
    raise Mimo::StandardError.new I18n.t(:"splash.not_found", :default => "No splash page found")
  end

  def self.not_clickthrough
    raise Mimo::StandardError.new I18n.t(:"splash.not_clickthrough", :default => "Clickthrough not enabled")
  end
end
