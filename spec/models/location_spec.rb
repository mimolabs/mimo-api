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

  describe 'helpers for the dashboard setup guide' do
    before(:each) do 
      REDIS.flushall
    end

    it 'should have a splash page setup' do
      location = Location.new id: 1
      expect(location.splash_page_created).to eq false

      key = "locSplashCreated:#{1}"
      REDIS.set key, 1
      expect(location.splash_page_created).to eq true
    end

    it 'should have an integration setup' do
      location = Location.new id: 1
      expect(location.integration_created).to eq false

    key = "locIntegCreated:#{1}"
      REDIS.set key, 1
      expect(location.integration_created).to eq true
    end

    it 'should have a campaign setup' do
      location = Location.new id: 1
      expect(location.campaign_created).to eq false

      key = "locCampCreated:#{1}"
      REDIS.set key, 1
      expect(location.campaign_created).to eq true
    end
  end
end
