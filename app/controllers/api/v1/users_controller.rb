# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!, except: %i[logout ping]

  respond_to :json

  def me
    @current_user = current_user
    @refresh_token = doorkeeper_token.refresh_token
    respond_with @current_user
  end

  def logout
    render status: 200, json: { message: 'You have logged out' }
  end
end
