require 'rails_helper'

describe SplashIntegration, :type => :model do

  before(:all) do
    @username = ENV['UNIFI_USER']
    @password = ENV['UNIFI_PASS']
    @hostname = ENV['UNIFI_HOST']
  end

  describe 'validation tests' do
    # it 'requires location_id' do
    # end
    #
    # it 'should always have a type!'

  end

  describe 'unifi' do
    describe '#get_credentials' do
      it 'authenticates user and returns unifi cookie' do
        VCR.use_cassette('unifi_201801051204', record: :new_episodes) do
          s = SplashIntegration.new username: @username, password: @password, host: @hostname
          s.save
          c = s.unifi_get_credentials
          expect(c).to be_an Object
          expect(c["cookie"]).not_to eq nil
        end
      end

      it 'should return false when credentials incorrect' do
        VCR.use_cassette('unifi_201801051208', record: :new_episodes) do
          s = SplashIntegration.new username: 'simone', password: 'sljfhsdf', host: @hostname
          s.save
          c = s.unifi_get_credentials
          expect(c).to eq false
        end
      end
    end

    describe '#create_ssid' do
      it 'creates an ssid' do
        VCR.use_cassette('unifi_201801051345', record: :new_episodes) do
          s = SplashIntegration.new username: @username, password: @password, host: @hostname
          s.save
          c = s.unifi_create_ssid({name: 'test ssid'})
          expect(c).to eq true
        end
      end

      it 'won\'t create an ssid with incorrect credentials' do
        VCR.use_cassette('unifi_201801051355', record: :new_episodes) do
          s = SplashIntegration.new username: 'simone', password: @password, host: @hostname
          s.save
          c = s.unifi_create_ssid({name: 'test ssid'})
          expect(c).to eq nil
        end
      end
    end

    describe 'update metadata' do
      it 'will save the ssid, the site id and desc as metadata' do
        VCR.use_cassette('unifi_201801101046', record: :new_episodes) do
          s = SplashIntegration.new username: @username, password: @password, host: @hostname
          s.save
          metadata = {ssid: 'test ssid', unifi_site_id: 'junk', unifi_site_name: 'default'}
          s.update(metadata: metadata)
          expect(s.metadata).to eq metadata
        end
      end
    end

    describe '#fetch_sites' do
      it 'should return default site' do
        VCR.use_cassette('unifi_201801051542', record: :new_episodes) do
          s = SplashIntegration.new username: @username, password: @password, host: @hostname
          s.save
          c = s.unifi_fetch_sites
          expect(c).to be_an Array
          expect(c).not_to be_empty
          expect(c[0]["desc"]).to eq "Default"
        end
      end
    end

    describe '#fetch_boxes' do
      it 'should return empty array from site without boxes' do
        VCR.use_cassette('unifi_201801051559', record: :new_episodes) do
          s = SplashIntegration.new username: @username, password: @password, host: @hostname
          s.save
          c = s.unifi_fetch_boxes
          expect(c).to be_an Array
          expect(c).to be_empty
        end
      end
    end

    describe '#cookies_to_object' do
      it 'converts cookie response to a ruby object' do
        s = SplashIntegration.new
        s.save
        cookie_response_string = 'csrf_token=uUQCpE8jKo6g45RmvSx2mE5OHXBKiOrN; Path=/; Secure, unifises=cjZtURZU77CQLIcncWLerT8vHU6ciLTK; Path=/; Secure; HttpOnly'
        expectation = {"cookie"=>"cjZtURZU77CQLIcncWLerT8vHU6ciLTK", "csrf_token"=>"uUQCpE8jKo6g45RmvSx2mE5OHXBKiOrN", "raw"=>"csrf_token=uUQCpE8jKo6g45RmvSx2mE5OHXBKiOrN; Path=/; Secure, unifises=cjZtURZU77CQLIcncWLerT8vHU6ciLTK; Path=/; Secure; HttpOnly"}
        expect(s.unifi_cookies_to_object(cookie_response_string)).to eq expectation
      end
    end
  end

end
