# frozen_string_literal: true

class SettingsPolicy < ApplicationPolicy

  def edit?
    puts 'hello'
    puts user
    puts settings
    true
  end

  private

  def settings
    record
  end

end
