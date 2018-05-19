# frozen_string_literal: true

class SplashPage < ApplicationRecord
  include Twilio
  before_create :generate_defaults

  def self.find_splash(opts)
    return splash_by_unique_id(opts) if opts[:splash_id].present?
    get_splash(opts)
  end

  def self.get_splash(opts)
    splash = allowed(opts)
    return SplashErrors.not_found unless splash.present?
    splash
  end

  def self.find_all_splash_pages(opts)
    splash = SplashPage.where(location_id: opts[:location_id], active: true)
                       .order(weight: :desc)
    return SplashErrors.not_found unless splash.present?
    splash
  end

  def allowed_now
    hr  = Time.now.hour
    day = Time.now.strftime('%w')

    start = available_start.to_i
    endd = available_end.to_i

    ### Start End hours must be >= now and <= now OR zeros
    return false if (hr < start || hr > endd) && start != 0 && endd != 0

    ### Check the day is allowed also
    return true if available_days.blank? || (available_days.include? day)

    false
  end

  def self.allowed(opts)
    splashes = find_all_splash_pages(opts)

    a = []
    splashes.each do |s|
      ok = s.allowed_now
      a << s if ok
    end

    return SplashErrors.not_available unless a.present?
    a.first
  end

  def form_code(_client_mac, _ip = nil)
    @splash = self
    form = LOGIN_FORM[20]['form']
    Mustache.render(form, @splash).gsub(/\r\n/m, "\n")
  end

  def is_eu
    true
  end

  def self.splash_by_unique_id(opts)
    splash = SplashPage.where(
      unique_id: opts[:splash_id],
      active: true
    ).order(weight: :desc).first
    return SplashErrors.not_found unless splash.present?
    splash
  end

  def login(opts)
    return unless validate_credentials(opts)

    ### email checks and validations
    ### radius checks

    process_login(opts)
  end

  def process_login(opts)
    integration = SplashIntegration.find_by location_id: location_id, active: true
    return SplashErrors.no_integration unless integration.present?

    case integration.integration_type
    when 'unifi'
      return unifi_response if integration.login_unifi_client(opts[:client_mac], session_timeout)
    end
  end

  def validate_credentials(opts)
    if otp_generate(opts)
      generate_otp(opts)
    elsif otp_login(opts)
      login_otp_user(opts)
    elsif password_login(opts)
      login_password_user(opts)
    else
      login_clickthrough_user(opts)
    end
  end

  def login_clickthrough_user(_opts)
    return true if backup_clickthrough
    SplashErrors.not_clickthrough
  end

  def login_password_user(opts)
    return true if opts[:password].downcase === password
    SplashErrors.splash_incorrect_password
  end

  def generate_otp(opts)
    validate_number(opts[:number])

    # expires = (Time.now + 5.minutes).to_i
    # code = SecureRandom.random_number(1000000)
    # # o = [('a'..'z')].map(&:to_a).flatten
    # # code = (0...5).map { o[rand(o.length)] }.join

    # otp = "#{code}.#{params[:clientMac]}"

    # otsc = OneTimeSplashCode.new
    # otsc.otp = otp
    # otsc.expires = expires
    # otsc.splash_page_id = id.to_s
    # return false unless otsc.save

    # send_otp(code, params)
  end

  def backup_clickthrough
    return true unless backup_sms || backup_password
    # || backup_email || backup_password ||
    #   fb_login_on || g_login_on || tw_login_on
    false
  end

  def password_login(opts)
    opts[:password].present? && backup_password
  end

  def otp_generate(opts)
    opts[:number] && backup_sms
  end

  def otp_login(opts)
    opts[:password] && opts[:otp]
  end

  def unifi_response
    { splash_id: id }
  end

  private

  def generate_defaults
    self.primary_access_id ||= 20

    self.default_password = SecureRandom.hex
    self.password           ||= Helpers.words
    self.unique_id          ||= SecureRandom.random_number(100_000_000_000_000)

    self.gdpr_form = false unless is_eu
  end
end
