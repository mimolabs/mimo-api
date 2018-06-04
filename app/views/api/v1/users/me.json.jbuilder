# frozen_string_literal: true

json.email @current_user.email
json.settings do 
  json.docs           @settings.docs_url
  json.terms          @settings.terms_url
  json.favicon        @settings.favicon.try(:url)
  json.logo           @settings.logo.try(:url)
  json.business_name  @settings.business_name
end
