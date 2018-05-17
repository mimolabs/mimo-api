class SplashIntegrationSites
  def self.matches?(request)
    request.query_parameters["action"] == "fetch_settings"
  end
end

class ApiLoginsCreate
  def self.matches?(request)
    request.query_parameters["callback"].present? && request.query_parameters["type"] == "create"
  end
end

class LoginsWelcome
  def self.matches?(request)
    request.query_parameters["welcome"].present?
  end
end
