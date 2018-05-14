# frozen_string_literal: true

class LocationPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    user.admin? || !record.published?
  end

  def show?
    location.user_id == user.id
  end
  
  private

  def location
    record
  end
end
