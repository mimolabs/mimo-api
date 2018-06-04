# frozen_string_literal: true

class Settings < ApplicationRecord

  mount_uploader :logo, LogoUploader

  before_create :generate_defaults
  validates_presence_of :business_name, :locale, :from_email

  private

  def generate_defaults
    self.unique_id ||= SecureRandom.uuid
  end
end
