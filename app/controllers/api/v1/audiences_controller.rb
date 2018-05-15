# frozen_string_literal: true

class Api::V1::AudiencesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[index create update destroy]
  respond_to :json

  def index
    @audiences = Audience.where(location_id: @location.id)
                         .page(params[:page])
                         .per(params[:per])
    authorize @audiences
  end

  def create
    parse_blob
    @audience = Audience.new(audience_params)
    @audience.location_id = @location.id
    respond_to do |format|
      if @audience.save
        format.json { 
          render template: 'api/v1/audiences/show.json.jbuilder', 
          status: 201
        }
      else
        @errors = @audience.errors.full_messages
        format.json { 
          render template: 'api/v1/shared/index.json.jbuilder', 
          status: 422
        }
      end
    end
  end

  def update
    parse_blob
    @audience = Audience.find_by(
      id: params[:id],
      location_id: @location.id
    )
    respond_to do |format|
      if @audience.present? && @audience.update(audience_params)
        format.json { 
          render template: 'api/v1/audiences/show.json.jbuilder',
          status: 201
        }
      else
        format.json { 
          render template: 'api/v1/shared/index.json.jbuilder',
          status: 422
        }
      end
    end
  end

  def destroy
    @audience = Audience.find_by(
      id: params[:id], location_id: @location.id
    )
    if @audience.destroy
      head :no_content
    else
      @errors = @audience.errors.full_messages
      render template: 'api/v1/shared/index.json.jbuilder', status: 422
    end
  end

  private

  def parse_blob
    blob = params[:audience][:blob]
    return unless blob.present?

    predicates = Base64.decode64(blob)
    data = JSON.parse(predicates, symbolize_names: true)

    params[:audience][:predicates] = data 
    params[:audience].delete(:blob)
  end

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end

  def audience_params
    params.require(:audience)
          .permit(predicates: [:attribute, :value, :operator, :relative])
  end
end
