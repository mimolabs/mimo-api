# frozen_string_literal: true

class Api::V1::SplashPagesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[index show update destroy]
  before_action :clean_params, only: %i[update create]
  respond_to :json

  def index
    @splash_pages = SplashPage.where(location_id: @location.id)
    authorize @splash_pages
  end

  def show; end

  def create
    # @location = Location.new user_id: current_user.id
    # respond_to do |format|
    #   if @location.update location_params
    #     format.json do
    #       render template: 'api/v1/locations/show.json.jbuilder',
    #              status: 201
    #     end
    #   else
    #     @errors = @location.errors.full_messages
    #     format.json do
    #       render template: 'api/v1/shared/index.json.jbuilder',
    #              status: 422
    #     end
    #   end
    # end
  end

  def update
    # respond_to do |format|
    #   if @location.update location_params
    #     format.json do
    #       render template: 'api/v1/locations/show.json.jbuilder',
    #              status: 201
    #     end
    #   else
    #     @errors = @location.errors.full_messages
    #     format.json do
    #       render template: 'api/v1/shared/index.json.jbuilder',
    #              status: 422
    #     end
    #   end
    # end
  end

  def destroy
    if @splash_page.destroy
      head :no_content
    else
      @errors = @splash_page.errors.full_messages
      render template: 'api/v1/shared/index.json.jbuilder', status: 422
    end
  end

  private

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location
  end

  def splash_params
    params.require(:splash_page).permit(:location_name)
  end

  def clean_params
    return unless params[:splash_page].present?
    options = JSON.parse params[:splash_page]
    params[:splash_page] = options if options
  rescue StandardError
  end
end
