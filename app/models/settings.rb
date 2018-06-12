# frozen_string_literal: true

class Settings < ApplicationRecord

  mount_uploader :logo, LogoUploader
  mount_uploader :favicon, FaviconUploader

  attr_accessor :code, :password, :wizard

  before_create :generate_defaults, :update_user_passy
  before_update :update_user_passy

  validates_presence_of :business_name, :locale, :logo, :favicon
  validates_presence_of :password, :if => :wizard
  validates :intercom_id, length: { maximum: 16 }
  validates :drift_id, length: { maximum: 16 }

  private

  def update_user_passy
    return unless password.present?
    puts 'Updating admin user!!!'
    u = User.where(role: 0).first
    u.update password: password, password_confirmation: password
  end

  def generate_defaults
    self.unique_id ||= SecureRandom.uuid
  end
end
