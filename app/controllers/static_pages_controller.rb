# frozen_string_literal: true

class StaticPagesController < ApplicationController
  respond_to :json, :html

  def health 
    render :status=>200, :json=> { message: "Willkommen, welcome, hai!" }
  end

  def ping
    render status: 200, json: {
      message: 'Oh hai' 
    }, callback: params[:callback]
  end
end
