# frozen_string_literal: true

class Api::V1::SplashIntegrationsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, only: %i[index show create update destroy]
  before_action :clean_params, only: %i[update create]
  respond_to :json

  def show
    @splash_integration = SplashIntegration.find_or_initialize_by(
      location_id: @location.id
    )
  end

  def create
    @splash_integration = SplashIntegration.new(splash_params)
    @splash_integration.location_id = @location.id
    respond_to do |format|
      if @splash_integration.save
        format.json { 
          render template: 'api/v1/splash_integrations/show.json.jbuilder',
          status: 201
        }
      else
        @errors = @splash_integration.errors.full_messages
        format.json {
          render template: 'api/v1/shared/index.json.jbuilder', 
          status: 422
        }
      end
    end
  end

  def update
    @splash_integration = SplashIntegration.find_by(id: params[:id], location_id: @current_resource.id)
    if !@splash_integration.present?
      render template: 'api/v1/shared/index.json.jbuilder', status: 422
    elsif params[:splash_integration][:action] == 'import_boxes'
      @results = @splash_integration.import_boxes
      respond_to do |format|
        format.json { render template: 'api/v1/splash_integrations/import_boxes.json.jbuilder', status: 200 }
      end
    else
      if params[:splash_integration] && params[:splash_integration][:metadata].present?
        params[:splash_integration][:metadata].reverse_merge! @splash_integration.metadata
      end
      if @splash_integration.update(splash_params)
        render status: 200, json: { message: 'Successfully updated' }
      else
        @errors = @splash_integration.errors.full_messages
        render template: 'api/v1/shared/index.json.jbuilder', status: 422
      end
    end
  end

  def destroy
    @splash_integration = SplashIntegration.find_by(
      id: params[:id], location_id: @location.id
    )
    if @splash_integration.destroy
      head :no_content
    else
      @errors = @splash_integration.errors.full_messages
      render template: 'api/v1/shared/index.json.jbuilder', status: 422
    end
  end

  private

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end

  def splash_params
    params.require(:splash_integration).permit(:username, :password, :host, :type, :action, metadata: %i[unifi_site_name unifi_site_id ssid zoneUUID organisation ssid network northbound_password ssid_id])
  end

  def clean_params
    return unless params[:splash_integration].present?
    options = JSON.parse params[:splash_integration]
    params[:splash_integration] = options if options
  rescue StandardError
  end
end
