# frozen_string_literal: true

class Api::V1::PersonTimelinesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!, except: [:portal_timeline]
  before_action :set_resource, except: [:portal_timeline]
  respond_to :json

  def index
    @timelines = PersonTimeline.where(location_id: @location.id)
                               .page(params[:page])
                               .per(params[:per])
    authorize @timelines
  end

  def portal_timeline
    respond_to do |format|
      if params[:code] == Person.portal_timeline_code(params[:person_id])
        location_id = Person.find_by(id: params[:person_id]).try(:location_id)
        @timelines = PersonTimeline.where(location_id: location_id,
                                          person_id: params[:person_id])
                                   .order(created_at: :desc).page(1).per(100)
        format.json {
          render template: 'api/v1/person_timelines/index.json.jbuilder',
          status: 200
        }
      else
        format.json {
          @errors = ["Unable to authenticate code"]
          render template: 'api/v1/shared/index.json.jbuilder',
          status: 422
        }
      end
    end
  end

  private

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end
end
