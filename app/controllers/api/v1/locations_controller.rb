# frozen_string_literal: true

class Api::V1::LocationsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, except: :index
  respond_to :json

  def index
    @locations = Location.where(user_id: current_user.id)
    authorize @locations
  end

  def show
  end 

  def update
    respond_to do |format|
      if @location.update location_params
        format.json {
          render template: 'api/v1/locations/show.json.jbuilder',
          status: 201
        }
      else
        @errors = @location.errors.full_messages
        format.json {
          render template: 'api/v1/shared/index.json.jbuilder',
          status: 422
        }
      end
    end
  end
  
  private

  def set_resource
    @location ||= Location.find_by(id: params[:id])
    authorize @location
  end

  def location_params
    params.require(:location).permit(:location_name)
  end
end
