# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user creating' do
    it 'should create the defaults after creating a user' do
      u = User.new email: Faker::Internet.email, password: 123123, password_confirmation: 123123, role: 0
      expect(u.save!).to be true
      expect(u.role).to eq 'admin'
      expect(u.reload.account_id).to be_present
    end
  end
end
