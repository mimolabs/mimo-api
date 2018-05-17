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

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable

  before_create :generate_defaults

  def set_default_role
    self.role ||= :user
  end

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
