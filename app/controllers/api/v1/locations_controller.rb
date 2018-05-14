# frozen_string_literal: true

class Api::V1::LocationsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_resource, except: :index
  respond_to :json

  def index
    @locations = Location.where(user_id: current_user.id)
    authorize @locations
  end

  def show

  end 
  
  private

  def set_resource
    @current_resource ||= Location.find_by(id: params[:id])
    authorize @current_resource
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def article_params
  #   params.require(:article).permit(:title, :body, :user_id)
  # end
end
