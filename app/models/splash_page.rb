# frozen_string_literal: true

class SplashPage < ApplicationRecord
  include Twilio

  mount_uploader :background_image_name, SplashBackgroundUploader
  mount_uploader :logo_file_name, SplashLogoUploader
  mount_uploader :header_image_name, SplashHeaderUploader

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

    return unless validate_email(opts)
    ### email checks and validations
    ### radius checks

    resp = process_login(opts)
    return unless resp.present?
    record_login(opts)

    resp
  end

  def process_login(opts)
    integration = SplashIntegration.find_by location_id: location_id, active: true
    return SplashErrors.no_integration unless integration.present?

    case integration.integration_type
    when 'unifi'
      return unifi_response if integration.login_unifi_client(opts[:client_mac], session_timeout)
    end
  end

  def record_login(opts)
    return if opts[:number].present?

    @login_params = {}
    @login_params[:location_id]       = location_id
    @login_params[:token]             = opts[:token]
    @login_params[:social_type]       = opts[:social_type]
    @login_params[:screen_name]       = opts[:screen_name]
    @login_params[:client_mac]        = opts[:client_mac]
    @login_params[:member_id]         = opts[:memberId]
    @login_params[:splash_id]         = id.to_s
    @login_params[:newsletter]        = opts[:newsletter]
    @login_params[:email]             = opts[:email]
    @login_params[:ap_mac]            = opts[:ap_mac]
    @login_params[:consent]           = opts[:consent]
    @login_params[:double_opt_in]     = double_opt_in
    @login_params[:timestamp]         = Time.now.to_i
    @login_params[:external_capture]  = newsletter_type.to_i > 1
    @login_params[:otp]               = opts[:otp]

    Sidekiq::Client.push('class' => "RecordLogin", 'args' => [@login_params])
  end

  def validate_email(opts)
    return SplashErrors.missing_email if email_required

    return true unless opts[:email].present?

    return true unless opts[:email].match(email_regex).blank?

    SplashErrors.invalid_email
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
    return true if backup_clickthrough || backup_sms
    SplashErrors.not_clickthrough
  end

  def login_otp_user(opts)
    params = { client_mac: opts[:client_mac], splash_id: id }
    code = OneTimeSplashCode.find(params)
    return SplashErrors.splash_incorrect_password if code.blank? || (code.to_s != opts[:password].to_s)
    true
  end

  def login_password_user(opts)
    return true if opts[:password].downcase === password
    SplashErrors.splash_incorrect_password
  end

  def generate_otp(opts)
    validate_number(opts[:number])

    params = {
      splash_id: id,
      client_mac: opts[:client_mac],
      location_id: location_id
    }

    code = OneTimeSplashCode.create(params)
    params[:code] = code

    send_otp(params)
  end

  def send_otp(params)
    Sidekiq::Client.push('class' => "OtpWorker", 'args' => [params])
    return true
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
    opts[:number] && backup_sms && !opts[:otp]
  end

  def otp_login(opts)
    opts[:password] && opts[:otp] && backup_sms
  end

  def unifi_response
    { splash_id: id }
  end

  ## Works out if the splash pages are in the EU. Currently, everyone is in the EU!
  def is_eu
    true
  end

  ##
  # Validates the emails sent in via the splash pages.

  def email_regex
    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end

  ##
  # Returns the full terms and conditions URL for the splash / login pages.
  # If the user has added a custom URL, it will take this. Otherwise, it will
  # calculate from the ENV vars set during the installation

  def terms_url_full
    return unless ENV['MIMO_API_URL'].present? || terms_url.present?

    terms_url ? terms_url : calc_terms_url
  end

  def calc_terms_url
    ENV['MIMO_API_URL'] + '/terms'
  end

  private

  def generate_defaults
    self.primary_access_id ||= 20

    self.gdpr_form          = false unless is_eu
    self.default_password   = SecureRandom.hex
    self.password           ||= Helpers.words
    self.unique_id          ||= SecureRandom.random_number(100_000_000_000_000)

    location = Location.find_by(id: location_id)
    self.splash_name = location.location_name if location.try(:location_name).present?
  end
end
