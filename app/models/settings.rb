# frozen_string_literal: true

class Settings < ApplicationRecord

  mount_uploader :logo, LogoUploader
  mount_uploader :favicon, FaviconUploader

  attr_accessor :code, :password

  before_create :generate_defaults
  after_update :update_user_passy

  validates_presence_of :business_name, :locale, :from_email, :password

  private

  def update_user_passy
    u = User.where(role: 0).first
    u.update password: password, password_confirmation: password
  end

  def generate_defaults
    self.unique_id ||= SecureRandom.uuid
  end
end
