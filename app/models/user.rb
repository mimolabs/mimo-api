# frozen_string_literal: true

class User < ApplicationRecord
  enum role: %i[admin editor user]
  after_initialize :set_default_role, if: :new_record?

  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all

  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all

  devise :database_authenticatable, :recoverable, :trackable, :validatable, :lockable, :timeoutable

  before_create :generate_defaults

  ##
  # Sets the role to a user if none specified
  # Make sure to update the bootstrapper if this changes 
  # otherwise it may create another admin user

  def set_default_role
    self.role ||= :user
  end

  def resend_code
    requested = REDIS.get('codeReq').present?
    return if requested.present?

    return if Settings.first.present?

    REDIS.setex('codeReq', 120, 1)
    UserMailer.with(user: self).new_code.deliver_now
  end

  ## 
  # Generates the account ID and other attributes for the user

  def generate_defaults
    self.account_id = generate_account_id
  end

  private

  def generate_account_id
    loop do
      @token = "M#{SecureRandom.uuid.split('-').first.upcase[0..5]}"
      break @token unless User.where(account_id: @token)
                              .select('account_id')
                              .first
    end
  end
end
