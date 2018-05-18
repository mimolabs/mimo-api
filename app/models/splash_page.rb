# frozen_string_literal: true

class SplashPage < ApplicationRecord
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
    form = LOGIN_FORM[20]['form']
    @splash = self
    Mustache.render(form, @splash).gsub(/\r\n/m, "\n")
  end

  def is_eu
    true
  end

  ### TODO include the time restrictions
  def self.splash_by_unique_id(opts)
    splash = SplashPage.where(
      unique_id: opts[:splash_id],
      active: true
    ).order(weight: :desc).first
    return SplashErrors.not_found unless splash.present?
    splash
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
