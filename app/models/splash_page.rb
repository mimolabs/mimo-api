# frozen_string_literal: true

class SplashPage < ApplicationRecord
  before_create :generate_defaults

  def self.find_splash(opts)
    return splash_by_unique_id(opts) if opts[:splash_id].present?
    get_splash(opts)
  end

  def get_splash
    splash = fetch_and_filter_splash(options)
    return splash if splash.present?
    errors.add :base, 'No splash pages found, please create one.'
    false
  end

  def fetch_and_filter_splash(opts)
    splashes = find_all_splash_pages(opts)
    first_available_splash(splashes, opts)
  end

  def find_all_splash_pages(opts)
    SplashPage.where(location_id: location_id, active: true).order(weight: :desc).to_a
  end

  # ## Finds by unique ID which helps direct to a specific splash page
  ### TODO include the time restrictions
  def self.splash_by_unique_id(opts)
    SplashPage.where(
      unique_id: opts[:splash_id],
      active: true
    ).order(weight: :desc).first
  end

  def first_available_splash(splashes, opts)
    ss = splashes.first if splashes.present?
    if splashes.length > 1
      splash_pages = allowed_splash(splashes, opts[:client_mac], opts[:uamip])
      if splash_pages.present?
        splash = splash_pages.select { |s| s[:allowed] == true }.first
        return splashes.select { |s| s.id.to_s == splash[:id] }.first if splash.present?
      end
      ss.splash_errors = ss.custom_quota_message
      return ss
    elsif splashes.length == 1
      unless ss.allowed_access(opts)
        ss.splash_errors = ss.custom_quota_message
      end
      return ss
    else
      errors.add :base, "<h2>Splash Not Found.</h2><p> Please check you've added this box to your dashboard and ensure it has a valid zone.</p>"
      false
    end
  end

  def form_code(_client_mac, _ip = nil)
    form = LOGIN_FORM[20]['form']
    @splash = self
    Mustache.render(form, @splash).gsub(/\r\n/m, "\n")
  end

  def is_eu
    true
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
