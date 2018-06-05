# frozen_string_literal: true

json.email @current_user.email
json.created_at @current_user.created_at.to_i
json.account_id @current_user.account_id || SecureRandom.hex

json.settings do 
  json.docs           @settings.docs_url
  json.terms          @settings.terms_url
  json.favicon        @settings.favicon.try(:url)
  json.logo           @settings.logo.try(:url)
  json.business_name  @settings.business_name
  json.intercom_id    @settings.intercom_id
  json.drift_id       @settings.drift_id
  json.integrations   [{ 
    unifi: @settings.integration_unifi,
    openmesh: @settings.integration_openmesh
  }]
end
