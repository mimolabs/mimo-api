# frozen_string_literal: true

class SplashIntegration < ApplicationRecord
  include Unifi

  attr_accessor :action

  before_validation :validate_integration,  if: lambda { |i| i.action == 'validate' }
  before_validation :create_setup,          if: lambda { |i| i.action == 'create_setup' }


  def log(response, meta = {}, opts = {})
    @body = JSON.parse(response.body) if response.try(:body).present?
    EventLog.create(
      location_id:            location_id,
      resource_id:            id.to_s,
      meta:                   meta,
      data:                   opts,
      response:               response,
      event_type:             'integration'
    )
  end

  def sync_attributes
    puts 'Syncing attrbutes'
  end

  def fetch_settings
    case integration_type
    when 'unifi'
      return unifi_fetch_sites
    end
  end

  def create_setup
    return ssid_error if !metadata['ssid'].present?
    case integration_type
    when 'unifi'
      return unless create_unifi_guest({name: metadata['ssid']})
    end

    self.active = true
    import_boxes
  end

  def import_boxes
    case integration_type
    when 'unifi'
      import_unifi_boxes
    end
  end

  def process_import_boxes(box,type)
    return Box.new(
      mac_address:      box['mac'],
      description:      box['name'],
      location_id:      location_id,
      machine_type:     integration_type
    )
  end

  def ssid_error
    errors.add :base, 'invalid or missing ssid'
  end

  private

  def validate_integration
    case integration_type
    when 'unifi'
      return unless validate_unifi
    end

    ### can only happen after validating
    sync_attributes
    true
  end
end
