# frozen_string_literal: true

class Api::V1::AudiencesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[index create update destroy]
  before_action :clean_params, only: %i[update create]
  respond_to :json

  def index
    @audiences = Audience.where(location_id: @location.id)
                         .page(params[:page])
                         .per(params[:per])
    authorize @audiences
  end

  # def create
  #   @person = Person.new location_id: @location.id
  #   respond_to do |format|
  #     if @person.update people_params
  #       format.json do
  #         render template: 'api/v1/people/show.json.jbuilder',
  #                status: 201
  #       end
  #     else
  #       @errors = @person.errors.full_messages
  #       format.json do
  #         render template: 'api/v1/shared/index.json.jbuilder',
  #                status: 422
  #       end
  #     end
  #   end
  # end

  # def update
  #   @person = Person.find_by(
  #     id: params[:id], location_id: @location.id
  #   )
  #   respond_to do |format|
  #     if @person.update people_params
  #       format.json do
  #         render template: 'api/v1/people/show.json.jbuilder',
  #                status: 200
  #       end
  #     else
  #       @errors = @person.errors.full_messages
  #       format.json do
  #         render template: 'api/v1/shared/index.json.jbuilder',
  #                status: 422
  #       end
  #     end
  #   end
  # end

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

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end

  # def people_params
  #   params.require(:person).permit(:last_name, :first_name, :username)
  # end

  # def clean_params
  #   return unless params[:person].present?
  #   options = JSON.parse params[:person]
  #   params[:person] = options if options
  # rescue StandardError
  # end
end
