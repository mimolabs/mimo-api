class SplashIntegrationSites
  def self.matches?(request)
    request.query_parameters["action"] == "fetch_settings"
  end
end
