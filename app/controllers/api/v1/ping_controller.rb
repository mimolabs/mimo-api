# frozen_string_literal: true

class Api::V1::PingController < Api::V1::BaseController
  respond_to :json

  def ping
    render status: 200, json: {
      message: 'Oh hai' 
    }, callback: params[:callback]
  end
end
