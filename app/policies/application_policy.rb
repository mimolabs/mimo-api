# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    puts 88376363636363636363636363
    puts 88376363636363636363636363
    puts 88376363636363636363636363
    puts 88376363636363636363636363
    puts 88376363636363636363636363
    puts 88376363636363636363636363
    puts 88376363636363636363636363
    puts 88376363636363636363636363
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
