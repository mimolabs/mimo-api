# frozen_string_literal: true

class Api::V1::StationsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource
  respond_to :json

  def index
    @stations = Station.where(location_id: @location.id)
                       .page(params[:page])
                       .per(params[:per])
    authorize @stations
  end

  def show
    @station = Station.find_by(id: params[:id], location_id: @location.id)
  end

  private

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end
end
