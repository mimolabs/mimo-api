# frozen_string_literal: true

class Location < ApplicationRecord
  has_many :location_users, :dependent => :destroy
  extend FriendlyId
  friendly_id :location_name_slugged, use: %i[slugged finders]

  validates_presence_of :user_id # , :location_name

  before_create :generate_defaults
  after_create :queue_background_jobs

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

  def queue_background_jobs
    Sidekiq::Client.push('class' => "LocationDefaults", 'args' => [id])
  end

  def generate_defaults
    self.unique_id ||= SecureRandom.hex
  end

  def location_name_slugged
    "#{location_name} #{SecureRandom.urlsafe_base64}"
  end
end
