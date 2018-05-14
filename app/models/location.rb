# frozen_string_literal: true

class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :location_name_slugged, use: %i[slugged finders]

  validates_presence_of :user_id

  before_create :generate_defaults

  def splash_page_created
    key = "locSplashCreated:#{id}"
    REDIS.get(key).present?
  end

  def integration_created
    key = "locIntegCreated:#{id}"
    REDIS.get(key).present?
  end

  def campaign_created
    key = "locCampCreated:#{id}"
    REDIS.get(key).present?
  end

  private

  def generate_defaults
    self.unique_id ||= SecureRandom.hex
  end

  def location_name_slugged
    "#{location_name} #{SecureRandom.urlsafe_base64}"
  end
end
