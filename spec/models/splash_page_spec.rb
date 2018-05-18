# frozen_string_literal: true

require 'rails_helper'
require 'errors'

RSpec.describe SplashPage, type: :model do

  let(:client_mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }
  let(:ap_mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }
  let(:ip) { '1.2.3.4' }

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

  describe 'tests for logging in' do
    it 'should log a unifi customer in' do
      s = SplashPage.new

      opts = {}
      expect(s.login(opts)).to eq true
    end

    it 'should login the email users bro'

  end

  describe 'tests for viewing the login pages' do
    it 'should find a splash page by unique id' do

      s = SplashPage.new location_id: 1
      s.save!

      opts = {}
      opts[:client_mac] = client_mac
      opts[:ap_mac]     = ap_mac
      opts[:uamip]      = ip
      opts[:splash_id]  = s.reload.unique_id

      login = SplashPage.find_splash(opts)
      expect(login).to eq s

      s.update active: false
      expect { SplashPage.find_splash(opts) }.to raise_error(Mimo::StandardError, 'No splash page found')
    end

    it 'should find a splash page - with no restrictions' do
      s = SplashPage.new location_id: 1
      s.save!

      opts = {}
      opts[:client_mac]  = client_mac
      opts[:ap_mac]      = ap_mac
      opts[:uamip]       = ip
      opts[:location_id] = 1

      login = SplashPage.find_splash(opts)
      expect(login).to eq s

      #### Wrong location
      opts[:location_id] = nil
      expect { SplashPage.find_splash(opts) }.to raise_error(Mimo::StandardError, 'No splash page found')

      #### Now with two - different weights - prioritise the higher
      s2 = SplashPage.create location_id: 1, weight: 1000
      opts[:location_id] = 1
      
      login = SplashPage.find_splash(opts)
      expect(login).to eq s2
    end

    it 'should find a splash page - time of day restrictions' do
      s = SplashPage.new location_id: 1, available_start: 30, available_end: 40
      s.save!

      opts = {}
      opts[:client_mac]  = client_mac
      opts[:ap_mac]      = ap_mac
      opts[:uamip]       = ip
      opts[:location_id] = 1

      expect { SplashPage.find_splash(opts) }.to raise_error(Mimo::StandardError, 'Not available at this time')
    end

    it 'should test the time of day allowance' do
      s = SplashPage.new location_id: 1, available_start: '30', available_end: '40'
      expect(s.allowed_now).to eq false

      s = SplashPage.new location_id: 1, available_start: '00', available_end: '00'
      expect(s.allowed_now).to eq true

      day = Time.now.yesterday.strftime('%w')
      s = SplashPage.new location_id: 1, available_start: '00', available_end: '00', available_days: [day]
      expect(s.allowed_now).to eq false

      day = Time.now.strftime('%w')
      s = SplashPage.new location_id: 1, available_start: '00', available_end: '00', available_days: [day]
      expect(s.allowed_now).to eq true
    end
  end
end
