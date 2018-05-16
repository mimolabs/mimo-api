# frozen_string_literal: true

class Api::V1::SocialsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[index show update destroy]
  before_action :clean_params, only: %i[update]
  respond_to :json

  def index
    @socials = Social.where(location_id: @location.id)
                     .page(params[:page])
                     .per(params[:per])
    authorize @socials
  end

  def show
    @social = Social.find_by(id: params[:id], location_id: @location.id)
  end

  private

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end
end
