module Twilio

  def missing_creds
    SplashErrors.twilio_missing_creds
  end

  def cache_number(number)
    key = "twilValidNum:#{number}"
    REDIS.setex(key, 86400, 1)
  end

  def valid_number(number)
    key = "twilValidNum:#{number}"
    val = REDIS.get(key)
    return val.present?
  end

  def validate_number(number)
    return true if valid_number(number)
    return missing_creds unless twilio_user && twilio_pass
    url = "https://lookups.twilio.com/v1/PhoneNumbers/#{number}?Type=carrier"
    conn = Faraday.new(:url => "#{url}") do |faraday|
      faraday.adapter  Faraday.default_adapter
    end
    conn.basic_auth(twilio_user, twilio_pass)
    response = conn.get do |req|
    end

    case response.status
    when 401
      return SplashErrors.twilio_invalid_creds
    when 404
      return SplashErrors.twilio_invalid_number
    when 200
      cache_number(number)
      return true
    end
    raise Mimo::StandardError.new I18n.t(:"splash.twilio_invalid", :default => "Unknown Twilio problem")
  end
end
