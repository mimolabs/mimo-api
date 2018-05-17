# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SplashPage, type: :model do
  describe 'on create' do
    it 'should have toggled the location splash page on'

    it 'should have created a unique id' do
      s = SplashPage.new location_id: 1
      s.save

      expect(s.unique_id).to be_present
      expect(s.primary_access_id).to eq 20
      expect(s.password).to be_present
      expect(s.default_password).to be_present
      expect(s.is_eu).to eq true
      expect(s.gdpr_form).to eq true
    end
  end

  describe 'tests for the login pages' do

    it 'should find a splash page by unique id' do
      s = SplashPage.new location_id: 1
      s.save!

      client_mac = (1..6).map{"%0.2X"%rand(256)}.join('-')
      ap_mac     = (1..6).map{"%0.2X"%rand(256)}.join('-')
      ip         = '1.2.3.4'

      opts = {}
      opts[:client_mac] = client_mac
      opts[:ap_mac]     = ap_mac
      opts[:uamip]      = ip
      opts[:splash_id]  = s.reload.unique_id

      login = SplashPage.find_splash(opts)
      expect(login).to eq s

      s.update active: false
      login = SplashPage.find_splash(opts)
      expect(login).to eq nil
    end

    it 'should find a splash page' do
      s = SplashPage.new location_id: 1
      s.save!

      client_mac = (1..6).map{"%0.2X"%rand(256)}.join('-')
      ap_mac     = (1..6).map{"%0.2X"%rand(256)}.join('-')
      ip         = '1.2.3.4'

      opts = {}
      opts[:client_mac] = client_mac
      opts[:ap_mac]     = ap_mac
      opts[:uamip]      = ip

      login = SplashPage.find_splash(opts)
      expect(login).to eq s
    end
  end
end
