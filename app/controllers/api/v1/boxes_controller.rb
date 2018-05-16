# frozen_string_literal: true

class Api::V1::BoxesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[index show create update destroy]
  respond_to :json

  def index
    @boxes = Box.where(location_id: @location.id)
    authorize @boxes
  end

  def destroy
    @box = Box.find_by(
      id: params[:id], location_id: @location.id
    )
    if @box.destroy
      head :no_content
    else
      @errors = @splash_page.errors.full_messages
      render template: 'api/v1/shared/index.json.jbuilder', status: 422
    end
  end

  private

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end
end
