# frozen_string_literal: true

class Person < ApplicationRecord
  self.table_name = 'people'

  def self.portal_timeline_code(person_id)
    REDIS.get("timelinePortalCode:#{person_id}")
  end

  def download_timeline(email_address)
    email_address ||= self.email
    return too_soon_error if within_24_hours
    return email_error unless email_address.present?
    opts = {
      person_id: id,
      email: email_address
    }
    Sidekiq::Client.push('class' => 'DownloadPersonTimeline', 'args' => [opts])
    day = 60*60*24
    REDIS.setex("timelineDataDownloaded:#{id}", day, true)
  end

  def within_24_hours
    REDIS.get("timelineDataDownloaded:#{id}").present?
  end

  def too_soon_error
    self.errors.add :base, 'Cannot download user timeline data more than once a day'
    false
  end

  def email_error
    self.errors.add :base, 'Must provide valid email address to download timeline data'
    false
  end
end
