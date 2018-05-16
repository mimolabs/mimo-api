# frozen_string_literal: true

class Api::V1::SendersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource
  respond_to :json

  def index
    @senders = Sender.where(location_id: @location.id)
                     .page(params[:page])
                     .per(params[:per])
    authorize @senders
  end

  def show
    @sender = Sender.find_by(id: params[:id], location_id: @location.id)
  end

  def create
    @sender = Sender.new(sender_params)
    @sender.location_id = @location.id
    @sender.user_id = @location.user_id

    respond_to do |format|
      if @sender.save
        format.json { render template: 'api/v1/senders/show.json.jbuilder', status: 201 }
      else
        @errors = @sender.errors.full_messages
        format.json { render template: 'api/v1/shared/index.json.jbuilder', status: 422 }
      end
    end
  end

  private

  def sender_params
    params.require(:sender).permit(:weight, :sender_name, :sender_type, :from_name, :from_email, :from_sms, :from_twitter, :twitter_token, :twitter_secret, :reply_email, :address, :town, :postcode, :country, :token)
  end

  def clean_params
    return unless params[:splash_page].present?
    options = JSON.parse params[:splash_page]
    params[:splash_page] = options if options
  rescue StandardError
  end

  def set_resource
    @location ||= Location.find_by(slug: params[:location_id])
    authorize @location, :show?
  end
end
