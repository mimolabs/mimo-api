##
## The Person model represents each person that logs into your network via a splash page.
## It links users by their mac or email addresses and saves their email address, name or whatever else the user might agree to give.
## A Person can have many Social, Email, Sms and Station.

class Person < ApplicationRecord
  self.table_name = 'people'

  before_destroy :remove_relations, prepend: true

  def self.portal_timeline_code(person_id)
    REDIS.get("timelinePortalCode:#{person_id}")
  end

  def self.create_timeline(email)
    Sidekiq::Client.push('class' => 'PersonTimelineRequest', 'args' => [{email: email}])
  end

  ##
  # This function is for the end user and primarily for GDPR purposes.
  # Via an open endpoint, users can request an email with an attachment of
  # all of the data we have associated with their email address. This can only
  # be requested once every 24 hours.

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

  ##
  # This function is used for GDPR purposes, to allow the end user to remove
  # their own data from our database via an open endpoint.

  def portal_request_destroy
    @portal_request = true
    clear_redis if self.destroy
  end

  def clear_redis
    REDIS.del("timelinePortalCode:#{id}")
  end

  ##
  # This function is run before a person is deleted from our database. It
  # triggers a job in the worker that removes all relations of the person. In
  # the case of the end user requesting the deletion, an email will be sent to
  # the location admin to notify.

  def remove_relations
    @options = {
      person_id: id,
      location_id: location_id
    }
    @options[:portal_request] = true if @portal_request
    Sidekiq::Client.push('class' => 'PersonDestroyRelations', 'args' => [@options] )
  end
end
