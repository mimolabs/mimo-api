require 'rails_helper'

describe SplashIntegration, :type => :model do

  before(:all) do
    @username = 'simon'
    @password = 'morley'
    @hostname = 'https://1.2.3.4:8443'

    # @username = ENV['UNIFI_USER']
    # @password = ENV['UNIFI_PASS']
    # @hostname = ENV['UNIFI_HOST']
  end


  describe 'validation tests' do
  end

  describe 'logging' do
    it 'should save the log' do
      s = SplashIntegration.new location_id: 123, id: 100
      response = {a: 'response'}
      body = {my: 'body'}

      s.log(response, body)

      el = EventLog.last
      expect(el.location_id).to eq 123
      expect(el.resource_id).to eq 100.to_s
      expect(el.event_type).to eq 'integration'
    end
  end

  describe 'unifi' do

    before(:each) do 
      REDIS.flushall

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
    end

    describe '#get_credentials' do
      it 'authenticates user and returns unifi cookie' do
        VCR.use_cassette('unifi_201801051204', record: :none) do
          s = SplashIntegration.new username: @username, password: @password, host: @hostname
          s.save

          c = s.unifi_get_credentials
          expect(c).to be_an Object
          expect(c["cookie"]).not_to eq nil
        end
      end
    end

    describe '#create_ssid' do
      it 'creates an ssid' do
        s = SplashIntegration.new username: @username, password: @password, host: @hostname
        s.save

        body = {"data"=>[{"_id"=>"5a4fa886ef0a81e2fb4d52f5", "attr_hidden_id"=>"Default", "attr_no_delete"=>true, "name"=>"Default", "site_id"=>"5a4fa885ef0a81e2fb4d52ea"}, {"_id"=>"5a4fa886ef0a81e2fb4d52f6", "attr_hidden"=>true, "attr_hidden_id"=>"Off", "attr_no_delete"=>true, "attr_no_edit"=>true, "name"=>"Off", "site_id"=>"5a4fa885ef0a81e2fb4d52ea"}, {"_id"=>"5a79c451ef0a7045891ad75d", "name"=>"111111", "pmf_mode"=>"disabled", "roam_channel_na"=>36, "roam_channel_ng"=>1, "roam_radio"=>"ng", "site_id"=>"5a4fa885ef0a81e2fb4d52ea"}, {"_id"=>"5a79c45eef0a7045891ad75e", "name"=>"2321321", "pmf_mode"=>"disabled", "roam_channel_na"=>36, "roam_channel_ng"=>1, "roam_radio"=>"ng", "site_id"=>"5a4fa885ef0a81e2fb4d52ea"}], "meta"=>{"rc"=>"ok"}}

        stub_request(:get, "https://1.2.3.4:8443/api/s/default/rest/wlangroup").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type'=>'application/json',
              'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
              'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
              'User-Agent'=>'Faraday v0.15.1'
            }).
            to_return(status: 200, body: body.to_json, headers: {})

        body = {"data"=>[{"_id"=>"5afcbe1def0a7045891bdd24", "enabled"=>true, "is_guest"=>true, "name"=>"test ssid", "security"=>"open", "site_id"=>"5a4fa885ef0a81e2fb4d52ea", "wlangroup_id"=>"5a4fa886ef0a81e2fb4d52f5", "x_iapp_key"=>"45bb09fbad0b6c2903f3578dd35e6308"}], "meta"=>{"rc"=>"ok"}}

        stub_request(:post, "https://1.2.3.4:8443/api/s/default/rest/wlanconf").
          with(
            body: "{\"enabled\":true,\"is_guest\":true,\"name\":\"test ssid\",\"security\":\"open\",\"wlangroup_id\":\"5a4fa886ef0a81e2fb4d52f5\"}",
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type'=>'application/json',
              'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
              'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
              'User-Agent'=>'Faraday v0.15.1'
            }).
            to_return(status: 200, body: body.to_json, headers: {})

        c = s.unifi_create_ssid({name: 'test ssid'})
        expect(c).to eq true
        # end
      end

      it 'won\'t create an ssid with incorrect credentials' do
        s = SplashIntegration.new username: 'simone', password: @password, host: @hostname
        s.save

        headers = { 'set-cookie': "csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly" }

        stub_request(:post, "https://1.2.3.4:8443/api/login").
          with(
            body: "{\"username\":\"simone\",\"password\":\"morley\"}",
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type'=>'application/json',
              'User-Agent'=>'Faraday v0.15.1'
            }).
            to_return(status: 401, body: "", headers: headers)

        c = s.unifi_create_ssid({name: 'test ssid'})
        expect(c).to eq nil
      end
    end

    describe 'update metadata' do
      it 'will save the ssid, the site id and desc as metadata' do
        VCR.use_cassette('unifi_201801101046', record: :none) do
          s = SplashIntegration.new username: @username, password: @password, host: @hostname
          s.save
          metadata = {ssid: 'test ssid', unifi_site_id: 'junk', unifi_site_name: 'default'}.to_json
          s.update(metadata: metadata)
          expect(s.metadata).to eq metadata
        end
      end
    end

    describe '#fetch_sites' do
      it 'should return default site' do
        s = SplashIntegration.new username: @username, password: @password, host: @hostname
        s.save
        stub_request(:get, "https://1.2.3.4:8443/api/self/sites").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
          'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
          'User-Agent'=>'Faraday v0.15.1'
           }).
         to_return(status: 200, body: site_data, headers: {})
         
        c = s.unifi_fetch_sites
        expect(c).to be_an Array
        expect(c).not_to be_empty
        expect(c[0]["desc"]).to eq "Site 3"
      end
    end

    describe '#fetch_boxes' do
      it 'should return empty array from site without boxes' do
        Box.destroy_all

        s = SplashIntegration.new username: @username, password: @password, host: @hostname, location_id: 1
        s.save

        stub_request(:get, "https://1.2.3.4:8443/api/s/default/stat/device").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type'=>'application/json',
              'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
              'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
              'User-Agent'=>'Faraday v0.15.1'
            }).
            to_return(status: 200, body: device_body, headers: {})  

        c = s.unifi_fetch_boxes
        expect(c).to be_an Array
        # annoying to test
        # expect(c).to be_empty
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

  def device_body
    a = {"data"=>[{"_id"=>"5a55f353ef0a81e2fb4d5355", "adopted"=>true, "antenna_table"=>[{"id"=>4, "name"=>"Combined", "wifi0_gain"=>3}], "cfgversion"=>"702bfc6b2bd5d3b9", "config_network"=>{"ip"=>"10.42.1.101", "type"=>"dhcp"}, "countrycode_table"=>[], "device_id"=>"5a55f353ef0a81e2fb4d5355", "ethernet_table"=>[{"mac"=>"00:27:22:54:42:74", "name"=>"eth0", "num_port"=>1}], "fw_caps"=>194603, "guest-num_sta"=>0, "has_eth1"=>false, "has_speaker"=>false, "inform_ip"=>"", "inform_url"=>"http:///inform", "ip"=>"192.168.1.44", "led_override"=>"default", "license_state"=>"registered", "mac"=>"00:27:22:54:42:74", "model"=>"BZ2", "na-guest-num_sta"=>0, "na-num_sta"=>0, "na-user-num_sta"=>0, "name"=>"Here it is!", "ng-guest-num_sta"=>0, "ng-num_sta"=>0, "ng-user-num_sta"=>0, "num_sta"=>0, "outdoor_mode_override"=>"default", "port_table"=>[], "radio_na"=>nil, "radio_ng"=>{"builtin_ant_gain"=>3, "builtin_antenna"=>true, "current_antenna_gain"=>0, "max_txpower"=>23, "min_txpower"=>5, "name"=>"wifi0", "nss"=>2, "radio"=>"ng", "radio_caps"=>16404}, "radio_table"=>[{"builtin_ant_gain"=>3, "builtin_antenna"=>true, "current_antenna_gain"=>0, "max_txpower"=>23, "min_txpower"=>5, "name"=>"wifi0", "nss"=>2, "radio"=>"ng", "radio_caps"=>16404}], "scan_radio_table"=>[], "serial"=>"002722544274", "site_id"=>"5a4fa885ef0a81e2fb4d52ea", "state"=>0, "type"=>"uap", "uplink_table"=>[], "user-num_sta"=>0, "version"=>"3.9.19.8123", "vwireEnabled"=>false, "vwire_table"=>[], "wifi_caps"=>15989, "wlangroup_id_ng"=>"5a4fa886ef0a81e2fb4d52f5", "x_authkey"=>"75ad7e2b794d1483efdcabd9c030ea1b", "x_fingerprint"=>"8a:0f:ce:41:5d:d2:8c:2f:80:8c:6a:31:2f:58:2b:78", "x_has_ssh_hostkey"=>false, "x_vwirekey"=>"8f8964c461e6215d788fcc357d5c8e63"}, {"_id"=>"5a5dd169ef0a7045891acabf", "adopted"=>true, "antenna_table"=>[], "board_rev"=>27, "cfgversion"=>"f06dac10446ac996", "config_network"=>{"ip"=>"192.168.0.27", "type"=>"dhcp"}, "countrycode_table"=>[], "device_id"=>"5a5dd169ef0a7045891acabf", "ethernet_table"=>[{"mac"=>"80:2a:a8:80:16:4b", "name"=>"eth0", "num_port"=>2}], "fw_caps"=>0, "guest-num_sta"=>0, "has_eth1"=>false, "has_speaker"=>false, "inform_ip"=>"", "inform_url"=>"", "ip"=>"10.42.1.108", "last_seen"=>1518176237, "license_state"=>"registered", "mac"=>"80:2a:a8:80:16:4b", "model"=>"U7LT", "na-guest-num_sta"=>0, "na-num_sta"=>0, "na-user-num_sta"=>0, "ng-guest-num_sta"=>0, "ng-num_sta"=>0, "ng-user-num_sta"=>0, "num_sta"=>0, "port_table"=>[], "radio_na"=>{"builtin_ant_gain"=>0, "builtin_antenna"=>true, "current_antenna_gain"=>0, "max_txpower"=>20, "min_txpower"=>4, "name"=>"wifi1", "nss"=>2, "radio"=>"na", "radio_caps"=>0}, "radio_ng"=>{"builtin_ant_gain"=>0, "builtin_antenna"=>true, "current_antenna_gain"=>0, "max_txpower"=>20, "min_txpower"=>4, "name"=>"wifi0", "nss"=>2, "radio"=>"ng", "radio_caps"=>0}, "radio_table"=>[{"builtin_ant_gain"=>0, "builtin_antenna"=>true, "current_antenna_gain"=>0, "max_txpower"=>20, "min_txpower"=>4, "name"=>"wifi0", "nss"=>2, "radio"=>"ng", "radio_caps"=>0}, {"builtin_ant_gain"=>0, "builtin_antenna"=>true, "current_antenna_gain"=>0, "max_txpower"=>20, "min_txpower"=>4, "name"=>"wifi1", "nss"=>2, "radio"=>"na", "radio_caps"=>0}], "scan_radio_table"=>[], "serial"=>"802AA880164B", "site_id"=>"5a4fa885ef0a81e2fb4d52ea", "state"=>0, "type"=>"uap", "uplink_table"=>[], "user-num_sta"=>0, "version"=>"3.4.7.3284", "vwireEnabled"=>false, "vwire_table"=>[], "wifi_caps"=>0, "wlangroup_id_na"=>"5a4fa886ef0a81e2fb4d52f5", "wlangroup_id_ng"=>"5a4fa886ef0a81e2fb4d52f5", "x_authkey"=>"e304bb9b7051d3637277b4384aa08164", "x_fingerprint"=>"a3:5e:8c:68:68:d1:84:b4:e8:72:cd:d1:75:ef:02:11", "x_has_ssh_hostkey"=>false, "x_vwirekey"=>"6aa25a01767970b24b88ad6db42cdc3b"}], "meta"=>{"rc"=>"ok"}}
    a.to_json

  end

  def site_data
    a = '{ "data" : [ { "_id" : "5a79c2e0ef0a7045891ad735" , "desc" : "Site 3" , "name" : "jcuq87bb" , "role" : "admin"} , { "_id" : "5a79c2e5ef0a7045891ad746" , "desc" : "Site 4" , "name" : "ja75u8cb" , "role" : "admin"} , { "_id" : "5a54f92bef0a81e2fb4d5317" , "desc" : "another site" , "name" : "4qqm5t2d" , "role" : "admin"} , { "_id" : "5a4fa885ef0a81e2fb4d52ea" , "attr_hidden_id" : "default" , "attr_no_delete" : true , "desc" : "Default" , "name" : "default" , "role" : "admin"} , { "_id" : "5a730d28ef0a7045891ad6ce" , "desc" : "11111" , "name" : "hycuz8ba" , "role" : "admin"} , { "_id" : "5a79c2d7ef0a7045891ad724" , "desc" : "Site 2" , "name" : "e8g5rn6t" , "role" : "admin"}] , "meta" : { "rc" : "ok"}}'
    a = JSON.parse a
    return a.to_json
  end
end
