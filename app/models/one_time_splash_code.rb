class OneTimeSplashCode

  def self.key(params)
    "otp:#{params[:client_mac]}:#{params[:splash_id]}"
  end

  def self.find(opts)
    k = key(opts)
    val = REDIS.get(k)
    return unless val.present?
    REDIS.del k
    true
  end

  def self.create(opts)
    code = SecureRandom.random_number(1_000_000)
    k = key(opts)
    REDIS.setex(k, 300, code)
    code
  end
end
