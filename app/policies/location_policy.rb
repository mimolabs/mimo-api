# frozen_string_literal: true

class LocationPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    user.admin? || (location.user_id == user.id)
  end

  def show?
    user.admin? || (location.user_id == user.id)
  end

  def destroy?
    user.admin? || (location.user_id == user.id)
  end
  
  private

  def location
    record
  end
end
