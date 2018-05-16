# frozen_string_literal: true

class Api::V1::LocationsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[show update destroy]
  before_action :clean_params, only: %i[update create]
  respond_to :json

  def index
    @locations = Location.where(user_id: current_user.id)
                         .page(params[:page])
                         .per(params[:per])
    authorize @locations
  end

  def show; end

  def create
    @location = Location.new user_id: current_user.id
    respond_to do |format|
      if @location.update location_params
        format.json do
          render template: 'api/v1/locations/show.json.jbuilder',
                 status: 201
        end
      else
        @errors = @location.errors.full_messages
        format.json do
          render template: 'api/v1/shared/index.json.jbuilder',
                 status: 422
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update location_params
        format.json do
          render template: 'api/v1/locations/show.json.jbuilder',
                 status: 200
        end
      else
        @errors = @location.errors.full_messages
        format.json do
          render template: 'api/v1/shared/index.json.jbuilder',
                 status: 422
        end
      end
    end
  end

  def destroy
    if @location.destroy
      head :no_content
    else
      @errors = @location.errors.full_messages
      render template: 'api/v1/shared/index.json.jbuilder', status: 422
    end
  end

  private

  def set_resource
    @location ||= Location.find_by(slug: params[:id])
    authorize @location
  end

  def location_params
    params.require(:location).permit(:location_name, :unique_id, :slug, :created_at, :updated_at, :location_address, :street, :postcode, :town, :country, :phone1, :api_token, :latitude, :longitude, :paid, :has_devices, :user_id, :eu, :demo, :timezone)
  end

  def clean_params
    return unless params[:location].present?
    options = JSON.parse params[:location]
    params[:location] = options if options
  rescue StandardError
  end
end
