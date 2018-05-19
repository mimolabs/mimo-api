# frozen_string_literal: true

require 'rails_helper'
require 'errors'

RSpec.describe SplashPage, type: :model do

  let(:location) { Location.create }
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
      # expect(s.login(opts)).to eq false
    end

    it 'should login the email users bro'

    it 'should validate the credentials - clickthrough user' do
      # s = SplashPage.new
      opts = {}

      # temp removed while we figure out what is a clickthrough
      # expect { s.validate_credentials(opts) }.to raise_error(Mimo::StandardError, 'Clickthrough not enabled')

      s = SplashPage.new backup_sms: false, backup_email: false, backup_password: false, fb_login_on: false, g_login_on: false, tw_login_on: false
      
      expect(s.validate_credentials(opts)).to eq true
    end
  end

  describe 'login UniFi' do

    before(:each) do
      SplashIntegration.destroy_all
    end

    it 'should log a unifi customer in' do
      s = SplashPage.new(
        backup_sms: false, backup_email: false, backup_password: false, fb_login_on: false, g_login_on: false, tw_login_on: false, location_id: 1001
      )
      opts = {}

      resp = { splash_id: s.id }
      expect { s.login(opts) }.to raise_error(Mimo::StandardError, "No integration found")

      si = SplashIntegration.create location_id: 1001, integration_type: 'unifi'
      expect { s.login(opts) }.to raise_error(Mimo::StandardError, "No integration found")

      ### Auth error
      si.update active: true
      expect { s.login(opts) }.to raise_error(Mimo::StandardError, "Could not authorise UniFi")

      headers = { 'set-cookie': "csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly" }
      stub_request(:post, "https://1.2.3.4:8443/api/login").
        with(
          body: "{\"username\":\"simon\",\"password\":\"morley\"}",
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: "", headers: headers)

       stub_request(:post, "https://1.2.3.4:8443/api/s//cmd/stamgr").
         with(
           body: "{\"mac\":null,\"cmd\":\"authorize-guest\",\"minutes\":60}",
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
          'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
          'User-Agent'=>'Faraday v0.15.1'
           }).
         to_return(status: 200, body: "", headers: {})

      si.update username: 'simon', password: 'morley', host: 'https://1.2.3.4:8443'
      expect(s.login(opts)).to eq resp

      stub_request(:post, "https://1.2.3.4:8443/api/s//cmd/stamgr").
         with(
           body: "{\"mac\":null,\"cmd\":\"authorize-guest\",\"minutes\":60}",
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
          'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
          'User-Agent'=>'Faraday v0.15.1'
           }).
         to_return(status: 401, body: "", headers: {})

      si.update username: 'simon', password: 'morley', host: 'https://1.2.3.4:8443'
      expect { s.login(opts) }.to raise_error(Mimo::StandardError, "Could not login UniFi client")
    end
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
