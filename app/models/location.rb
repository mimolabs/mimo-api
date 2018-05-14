class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :location_name_slugged, use: [:slugged, :finders]

  validates_presence_of :user_id

  before_create :generate_defaults

  private

  def generate_defaults
    self.unique_id ||= SecureRandom.hex
  end

  def location_name_slugged
    "#{location_name} #{SecureRandom.urlsafe_base64}"
  end
end
