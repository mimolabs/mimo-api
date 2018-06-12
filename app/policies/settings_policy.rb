# frozen_string_literal: true

class SettingsPolicy < ApplicationPolicy

  def edit?
    user.present? && user.admin?
  end

  def update?
    edit?
  end

  private

  def settings
    record
  end
end
