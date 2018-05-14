# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'location creating' do
    it 'should should be invalid without a user id' do
      location = Location.new
      expect(location.save).to eq false

      location.user_id = 1
      expect(location.save).to eq true
    end

    it 'should create the defaults after creating a location' do
      location = Location.create user_id: 100
      expect(location.unique_id).to be_present
    end
  end
end
