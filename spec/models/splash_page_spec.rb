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
    it 'should login the email users bro'

    it 'should validate a clickthrough user' do
      # s = SplashPage.new
      opts = {}

      # temp removed while we figure out what is a clickthrough
      # expect { s.validate_credentials(opts) }.to raise_error(Mimo::StandardError, 'Clickthrough not enabled')

      s = SplashPage.new backup_sms: false, backup_email: false, backup_password: false, fb_login_on: false, g_login_on: false, tw_login_on: false
      
      expect(s.validate_credentials(opts)).to eq true
    end

    it 'should validate a password user' do
      opts = {}
      s = SplashPage.new backup_password: true 
      expect { s.validate_credentials(opts) }.to raise_error(Mimo::StandardError, 'Clickthrough not allowed')

      opts[:password] = 'cheese'
      expect { s.validate_credentials(opts) }.to raise_error(Mimo::StandardError, 'Password incorrect')

      s.password = 'cheese'
      expect(s.validate_credentials(opts)).to eq true
    end

    it 'should should validate the phone number against the Twilio API for OTP logins' do
      opts = {}
      s = SplashPage.new backup_sms: true 
      opts[:number] = '+44777777777777'

      # expect { s.validate_credentials(opts) }.to raise_error(Mimo::StandardError, 'Invalid phone number')
      expect { s.validate_credentials(opts) }.to raise_error(Mimo::StandardError, 'Missing Twilio credentials')

      s.twilio_user = 'simon'
      s.twilio_pass = 'simon'

      stub_request(:get, "https://lookups.twilio.com/v1/PhoneNumbers/+44777777777777?Type=carrier").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic c2ltb246c2ltb24=',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 404, body: "", headers: {})
          
      expect { s.validate_credentials(opts) }.to raise_error(Mimo::StandardError, 'Invalid phone number')

      stub_request(:get, "https://lookups.twilio.com/v1/PhoneNumbers/+44777777777777?Type=carrier").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic c2ltb246c2ltb24=',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: "", headers: {})
          
      expect(s.validate_credentials(opts)).to eq true
    end

    it 'should should generate an OTP and queue job to send message' do
      opts = {}

      mac = client_mac
      s = SplashPage.new backup_sms: true, id: 100
      opts[:number]     = '+44777777777777'
      opts[:client_mac] = mac 

      s.twilio_user = 'simon'
      s.twilio_pass = 'simon'

      stub_request(:get, "https://lookups.twilio.com/v1/PhoneNumbers/+44777777777777?Type=carrier").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic c2ltb246c2ltb24=',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: "", headers: {})
          
      expect(s.generate_otp(opts)).to eq true

      key = "otp:#{mac}:#{s.id}"
      expect(REDIS.get(key)).to be_present

      params = { client_mac: mac, splash_id: s.id }
      expect(OneTimeSplashCode.find(params)).to be_present
      
      expect(REDIS.get(key)).to eq nil
    end

    it 'should login an OTP user' do
      opts = {}

      mac = client_mac
      s = SplashPage.new backup_sms: true, id: 100, twilio_user: 'simon', twilio_pass: 'simon', location_id: 100
      si = SplashIntegration.create! location_id: 100, integration_type: 'unifi', active: true, host: 'https://1.2.3.4:8443', username: 'simon', password: 'morley'

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
         body: "{\"mac\":\"#{mac}\",\"cmd\":\"authorize-guest\",\"minutes\":60}",
         headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
        'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
        'User-Agent'=>'Faraday v0.15.1'
         }).
       to_return(status: 200, body: "", headers: {})

      opts[:client_mac] = mac 
      opts[:otp]        = true
      opts[:password]   = 123

      expect { s.login(opts) }.to raise_error(Mimo::StandardError, 'Password incorrect')

      ### Generate a code for the user
      stub_request(:get, "https://lookups.twilio.com/v1/PhoneNumbers/?Type=carrier").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic c2ltb246c2ltb24=',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: "", headers: {})

      temp = { client_mac: mac }
      s.generate_otp(temp)

      ### Get the code from redis
      key = "otp:#{mac}:#{s.id}"
      code = REDIS.get(key)

      opts[:password] = code
      resp = { splash_id: s.id }

      expect(s.login(opts)).to eq resp
    end

    it 'should validate the email' do
      s = SplashPage.new id: 282, location_id: 1001
      SplashIntegration.create location_id: 1001, integration_type: 'unifi', active: true

      opts = { email: 'b' }
      expect { s.login(opts) }.to raise_error(Mimo::StandardError, 'Invalid email address')

      opts[:email] = 'help@oh-mimo.com'

      ### Raises an error since we've not bothered to log the unifi in
      expect { s.login(opts) }.to raise_error(Mimo::StandardError, "Could not authorise UniFi")

      opts = { }
      expect { s.login(opts) }.to raise_error(Mimo::StandardError, "Could not authorise UniFi")

      s.email_required = true
      expect { s.login(opts) }.to raise_error(Mimo::StandardError, 'Missing email address')
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

  describe 'OTP Logins' do
    it 'should validate a number via twilio' do
      s = SplashPage.new

      number = '00000000'
      expect { s.validate_number(number) }.to raise_error(Mimo::StandardError, 'Missing Twilio credentials')

      s.twilio_user = 'simon'
      s.twilio_pass = 'morley'

      stub_request(:get, "https://lookups.twilio.com/v1/PhoneNumbers/00000000?Type=carrier").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic c2ltb246bW9ybGV5',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 401, body: "", headers: {})
      
      expect { s.validate_number(number) }.to raise_error(Mimo::StandardError, 'Invalid Twilio credentials')

      stub_request(:get, "https://lookups.twilio.com/v1/PhoneNumbers/00000000?Type=carrier").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic c2ltb246bW9ybGV5',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 404, body: "", headers: {})
      
      expect { s.validate_number(number) }.to raise_error(Mimo::StandardError, 'Invalid phone number')

      stub_request(:get, "https://lookups.twilio.com/v1/PhoneNumbers/00000000?Type=carrier").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic c2ltb246bW9ybGV5',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: "", headers: {})
      
        expect(s.validate_number(number)).to eq true
        expect(s.valid_number(number)).to eq true
    end
  end
end
