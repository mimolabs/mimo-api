class Api::V1::BaseController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action :cors_preflight_check
  after_action :cors_set_headers

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  private

  def not_found
    render :status=>404, :json=>{:message=>"Not found."}
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

end

