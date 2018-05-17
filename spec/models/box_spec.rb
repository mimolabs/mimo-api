# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Box, type: :model do
  describe 'validation' do
    it 'should not create a duplicate by mac address' do
      mac = (1..6).map{"%0.2X"%rand(256)}.join('-')
      b = Box.new mac_address: mac, location_id: 1
      expect(b.save).to eq true

      b = Box.new mac_address: mac, location_id: 1
      expect(b.save).to eq false
    end

    it 'should clean the mac before save' do
      mac = (1..6).map{"%0.2X"%rand(256)}.join(':')
      b = Box.new mac_address: mac, location_id: 1
      expect(b.save).to eq true
      expect(b.reload.mac_address).to eq mac.gsub(':','-')
    end
  end
end
