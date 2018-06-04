# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!, except: %i[logout]
  before_action :set_resource

  respond_to :json

  def index
    @user = current_user
  end

  def me
    @settings = Settings.first_or_initialize
    @current_user = current_user
    @refresh_token = doorkeeper_token.refresh_token
    respond_with @current_user
  end

  def logout
    render status: 200, json: { message: 'You have logged out' } # not they haven't
  end

  private

  def set_resource
    # @location ||= Location.find_by(slug: params[:location_id])
    # authorize @location, :show?
  end
end
