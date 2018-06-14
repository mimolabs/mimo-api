# frozen_string_literal: true

class SplashPagePolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    user.admin?
  end

  def show?
    # user.admin? || (location.user_id == user.id)
  end

  def destroy?
    # user.admin? || (location.user_id == user.id)
  end

  private

  def splash
    record
  end
end
