# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user creating' do
    it 'should create the defaults after creating a user' do
      u = User.create email: Faker::Internet.email, password: 1231, password_confirmation: 1231, role: 0
      expect(u.role).to eq 'admin'
    end
  end
end
