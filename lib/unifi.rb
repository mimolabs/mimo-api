module Unifi
  #### manual setup ####
  # s = SplashIntegration.new host: host, username: 'simon', password: 'eggmon1818', location_id: 2586, type: 'unifi'
  # fetch wlan groups
  # s.unifi_fetch_wlan_groups
  # set metadata with stuff
  # s.metadata[:unifi_site_name] = 'default'
  # s.metadata[:unifi_site_id] = '5a4fa885ef0a81e2fb4d52ea'
  # s.metadata[:ssid] = 'May the forth'
  # s.update action: 'validate'
  # s.create_unifi_guest({name: s.metadata[:ssid]})

  def import_unifi_boxes
    puts 'Importing UniFi boxes'
    boxes = unifi_fetch_boxes

    return {} unless boxes.present?

    success = 0
    failed = []

    boxes.each do |box|
      mac = Polkaspots.clean_mac box['mac']
      puts "Importing #{mac}"
      n = process_import_boxes(box, 'unifi')
      n.save ? (success += 1) : (failed << mac)
    end

    obj =  { success: success, failed: failed }
    return obj
  end

  def unifi_cookies_to_object(cookies)
    obj = {}

    m = cookies.match(/unifises=(.*?);/)
    obj['cookie'] = m[1]

    m = cookies.match(/csrf_token=(.*?);/)
    obj['csrf_token'] = m[1]
    obj['raw'] = cookies

    REDIS.setex(unifi_cookies_key, 600, obj.to_json)

    return obj
  end

  def cached_unifi_results
    val = REDIS.get(unifi_cookies_key)
    return unless val.present?

    puts 'Returning cached sites'
    JSON.parse(val)
  end

  def timeout_error
    errors.add :base, 'could not contact host'
  end

  ### write tests
  def validate_unifi
    opts = { username: username, password: password }
    response = post_unifi('/login', opts)
    return timeout_error unless response.present?
    return true if response.status == 200
    errors.add :base, 'Username or password for UniFi controller invalid'
    false
  end

  def unifi_get_credentials # validate account
    cached = cached_unifi_results
    return cached if cached.present?

    # You should also ensure we return nil if the credentials are wrong
    # put a section in that will flag as invalid so the user can update

    opts = { username: username, password: password }
    response = post_unifi('/login', opts)

    return false unless response.present?
    case response.status
    when 200
      cookies = response.env[:response_headers]['set-cookie']
      return unifi_cookies_to_object(cookies)
    else
      puts 'Oh no!'
      false
    end
  end

  def login_unifi_client(client_mac, minutes=60, logout=false)
    cookies = unifi_get_credentials
    return unless cookies.present?

    conn = Faraday.new(
      url: host + "/api/s/#{metadata[:unifi_site_name]}/cmd/stamgr",
      ssl: { verify: false }
    )

    cmd = logout ? 'unauthorize-guest' : 'authorize-guest'
    opts = {mac: client_mac, cmd: cmd, minutes: minutes}
    begin
      response = conn.post do |req|
        req.body                      = opts.to_json
        req.headers['Content-Type']   = 'application/json'
        req.headers['cookie']         = cookies["raw"]
        req.headers['csrf_token']     = cookies["csrf_token"]
        req.options.timeout           = 3
        req.options.open_timeout      = 2
      end

      # log(response, opts)
      case response.status
      when 200
        puts "wooohooo!"
        return true
      else
        puts resp.inspect
        # errors.add :base, human_unifi_error(error)
        return false
      end
    rescue => e
      Rails.logger.info e
      errors.add :base, 'Timeout error, please check host'
      # log({status: 0}, opts)
      false
    end
  end

  def human_unifi_error(error)
    case error
    when 'api.err.TooManyWirelessNetwork'
      return 'Too many wireless networks. Delete one within your UniFi controller before retrying.'
    else
      return error
    end
  end

  def unifi_create_ssid(params)
    cookies = unifi_get_credentials
    return unless cookies.present?

    wlan_group_id = unifi_fetch_wlan_groups

    opts = {}
    site_name = metadata[:unifi_site_name] || 'default'
    path = "/s/#{site_name}/rest/wlanconf"

    opts[:enabled]      = true
    opts[:is_guest]     = true
    opts[:name]         = params[:name]
    opts[:security]     = params[:security] == 'wpa' ? 'wpapsk' : 'open'
    opts[:x_passphrase] = params[:password] if params[:password].present? && params[:security] == 'wpa'
    opts[:wlangroup_id] = wlan_group_id[0]['_id']

    response = post_unifi(path, opts, cookies)

    return timeout_error unless response.present?
    case response.status
    when 200
      puts 'created SSID'
      return true
    else
      body = JSON.parse(response.body)
      error = body['meta']['msg']
      errors.add :base, human_unifi_error(error)
      false
    end
  end

  def unifi_fetch_wlan_groups
    cookies = unifi_get_credentials
    return unless cookies.present?

    site_name = metadata[:unifi_site_name] || 'default'
    path = "/s/#{site_name}/rest/wlangroup"

    resp = get_unifi(path, {}, cookies)

    return unless resp.present?

    case resp.status
    when 200
      return JSON.parse(resp.body)['data']
    end
  end

  def unifi_fetch_boxes
    cookies = unifi_get_credentials
    return unless cookies.present?

    site_name = metadata[:unifi_site_name] || 'default'
    path = "/s/#{site_name}/stat/device"
    resp = get_unifi(path, {}, cookies)

    return unless resp.present?

    case resp.status
    when 200
      return JSON.parse(resp.body)['data']
    end
  end

  def fetch_cached_sites
    val = REDIS.get "unifiSites:#{id}"
    return unless val.present?
    JSON.parse val
  end

  def unifi_fetch_sites
    cached_sites = fetch_cached_sites
    return cached_sites if cached_sites.present?

    cookies = unifi_get_credentials
    return unless cookies.present?

    path = '/self/sites'
    resp = get_unifi(path, {}, cookies)

    return unless resp.present?

    case resp.status
    when 200
      body = JSON.parse(resp.body)['data']
      REDIS.setex "unifiSites:#{id}", 120, body.to_json
      return body
    end
  end

  def fetch_guest_id
    settings = fetch_unifi_settings
    return unless settings.present?

    settings.each do |setting|
      if setting['key'] == 'guest_access'
        return setting['_id']
      end
    end
  end

  def fetch_unifi_settings
    cookies = unifi_get_credentials
    return unless cookies.present?

    site_name = metadata[:unifi_site_name] || 'default'
    path = "/s/#{site_name}/get/setting"
    resp = get_unifi(path, {}, cookies)

    return unless resp.present?

    case resp.status
    when 200
      return JSON.parse(resp.body)['data']
    end
  end

  ### These need errors.add.base
  def create_unifi_guest(params)
    return false unless create_guest_settings
    puts 'Created guest settings'
    return unifi_create_ssid(params)
  end

  def create_guest_settings
    cookies = unifi_get_credentials
    return unless cookies.present?

    guest_id = fetch_guest_id

    return unless guest_id
    site_id = metadata[:unifi_site_id]

    sites = unifi_fetch_sites
    return unless sites.present?

    site = sites.select { |s| s['_id'] == site_id }.first
    return unless site.present?

    site_name = site['name']
    metadata[:unifi_site_name] = site_name

    path = "/s/#{site_name}/set/setting/guest_access/#{guest_id}"
    opts = {}
    opts[:_id]                        = guest_id
    opts[:auth]                       = 'custom'
    opts[:site_id]                    = site_id
    opts[:key]                        = 'guest_access'
    opts[:redirect_https] = false
    opts[:restricted_subnet_1] = ''
    opts[:restricted_subnet_2] = ''
    opts[:restricted_subnet_3] = ''
    opts[:portal_customized_title] = 'Hotspot portal'
    opts[:voucher_enabled] = true
    opts[:payment_fields_address_enabled] = true
    opts[:payment_fields_address_required] = true
    opts[:payment_fields_city_enabled] = true
    opts[:payment_fields_city_required] = true
    opts[:payment_fields_country_default] = ''
    opts[:payment_fields_country_enabled] = true
    opts[:payment_fields_country_required] = true
    opts[:payment_fields_email_enabled] = true
    opts[:payment_fields_email_required] = false
    opts[:payment_fields_first_name_enabled] = true
    opts[:payment_fields_first_name_required] = true
    opts[:payment_fields_last_name_enabled] = true
    opts[:payment_fields_last_name_required] = true
    opts[:payment_fields_state_enabled] = true
    opts[:payment_fields_state_required] = true
    opts[:payment_fields_zip_enabled] = true
    opts[:payment_fields_zip_required] = true
    opts[:portal_customized_bg_color] = '#233041'
    opts[:portal_customized_bg_image_enabled] = true
    opts[:portal_customized_bg_image_tile] = false
    opts[:portal_customized_box_color] = '#000000'
    opts[:portal_customized_box_link_color] = '#000000'
    opts[:portal_customized_box_text_color] = '#000000'
    opts[:portal_customized_box_opacity] = '90'
    opts[:portal_customized_button_color] = '#1379b7'
    opts[:portal_customized_button_text_color] = '#ffffff'
    opts[:portal_customized_link_color] = '#000000'
    opts[:portal_customized_logo_enabled] = true
    opts[:portal_customized_text_color] = '#000000'
    opts[:portal_customized_languages] = ['en']
    opts[:expire] = 480
    opts[:redirect_enabled] = false
    opts[:redirect_url] = ''
    opts[:template_engine] = 'angular'
    opts[:radius_auth_type] = 'mschapv2'
    opts[:facebook_wifi_gw_name] = 'Default'
    opts[:portal_enabled] = true
    opts[:custom_ip] = '104.27.81.36'
    opts[:portal_use_hostname] = true
    opts[:portal_hostname]    = 's.oh-mimo.com'
    opts[:allowed_subnet_1]   = 'ctapp.io'
    opts[:allowed_subnet_2]   = 'd247kqobagyqjh.cloudfront.net'
    opts[:allowed_subnet_3]   = '104.27.81.36'
    opts[:allowed_subnet_4]   = 'oh-mimo.com'
    opts[:allowed_subnet_5]   = 'facebook.com'
    opts[:allowed_subnet_6]   = 'facebook.net'
    opts[:allowed_subnet_7]   = 'fbcdn.net'
    opts[:allowed_subnet_8]   = 'www.google-analytics.com'
    opts[:redirect_https] = true

    resp = post_unifi(path, opts, cookies)

    return unless resp.present?

    case resp.status
    when 200
      return true
    end
    return false
  end

  def get_unifi(path, opts={}, cookies=nil)
    conn = Faraday.new(
      url: host + "/api#{path}",
      ssl: { verify: false }
    )
    response = conn.get do |req|
      req.body                      = opts.to_json if opts.present?
      req.headers['Content-Type']   = 'application/json'
      if cookies.present?
        req.headers['cookie']         = cookies["raw"]
        req.headers['csrf_token']     = cookies["csrf_token"]
      end
      req.options.timeout           = 3
      req.options.open_timeout      = 2
    end
    # log(response, opts)
    return response

  # rescue => e
  #   Rails.logger.info e
  #   # log({status: 0}, opts)
  #   false
  end

  def post_unifi(path, opts={}, cookies=nil)
    conn = Faraday.new(
      url: host + "/api#{path}",
      ssl: { verify: false }
    )
    resp = conn.post do |req|
      req.body                      = opts.to_json if opts.present?
      req.headers['Content-Type']   = 'application/json'
      if cookies.present?
        req.headers['cookie']         = cookies["raw"]
        req.headers['csrf_token']     = cookies["csrf_token"]
      end
      req.options.timeout           = 3
      req.options.open_timeout      = 2
    end
    # log(resp)
    return resp
  # rescue => e
  #   Rails.logger.info e
  #   # log({status: 0}, opts)
  #   false
  end

  def unifi_cookies_key
    "unifiCookiesV2:#{id}"
  end
end
