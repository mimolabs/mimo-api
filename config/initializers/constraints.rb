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

class EmailConfirm
  def self.matches?(request)
    request.query_parameters["code"].present? && request.query_parameters["action"] == 'confirm'
  end
end

class PortalTimeline
  def self.matches?(request)
    request.query_parameters["code"].present?
  end
end