# frozen_string_literal: true

class Api::V1::SplashPagesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[index show create update destroy]
  before_action :clean_params, only: %i[update create]
  respond_to :json

  def index
    @splash_pages = SplashPage.where(location_id: @location.id)
    authorize @splash_pages
  end

  def show
    @splash_page = SplashPage.find_by(id: params[:id], location_id: @location.id)
  end

  def create
    @splash_page = SplashPage.new location_id: @location.id
    respond_to do |format|
      if @splash_page.update splash_params
        format.json do
          render template: 'api/v1/splash_pages/show.json.jbuilder',
                 status: 201
        end
      else
        @errors = @splash_page.errors.full_messages
        format.json do
          render template: 'api/v1/shared/index.json.jbuilder',
                 status: 422
        end
      end
    end
  end

  def update
    @splash_page = SplashPage.find_by(
      id: params[:id], location_id: @location.id
    )
    respond_to do |format|
      if @splash_page.update splash_params
        format.json do
          render template: 'api/v1/splash_pages/show.json.jbuilder',
                 status: 200
        end
      else
        @errors = @splash_page.errors.full_messages
        format.json do
          render template: 'api/v1/shared/index.json.jbuilder',
                 status: 422
        end
      end
    end
  end

  def destroy
    @splash_page = SplashPage.find_by(
      id: params[:id], location_id: @location.id
    )
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
    authorize @location, :show?
  end

  def splash_params
    params.require(:splash_page).permit(:weight)
  end

  def clean_params
    return unless params[:splash_page].present?
    options = JSON.parse params[:splash_page]
    params[:splash_page] = options if options
  rescue StandardError
  end
end
