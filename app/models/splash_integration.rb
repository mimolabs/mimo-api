# frozen_string_literal: true

class SplashIntegration < ApplicationRecord
  include Unifi

  def log(response, meta={}, opts={})
    @body = JSON.parse(response.body) if response.try(:body).present?
    EventLog.create({
      location_id:            location_id,
      resource_id:            id.to_s,
      meta:                   meta,
      data:                   opts,
      response:               response,
      event_type:             'integration'
    })
  end
end
