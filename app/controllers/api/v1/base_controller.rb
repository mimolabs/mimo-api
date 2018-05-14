# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :cors_preflight_check
  after_action :cors_set_headers

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render status: 404, json: { message: 'Not found.' }
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.try(:resource_owner_id)) if doorkeeper_token.present?
  end

  def user_not_authorized
    head :forbidden
  end
end
