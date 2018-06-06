# frozen_string_literal: true

class Person < ApplicationRecord
  self.table_name = 'people'

  def self.portal_timeline_code(person_id)
    REDIS.get("timelinePortalCode:#{person_id}")
  end
end
