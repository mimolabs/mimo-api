# frozen_string_literal: true

class StaticPagesController < ApplicationController

  protect_from_forgery with: :null_session, only: :eggs

  respond_to :json, :html

  def eggs
    puts response.body
    render :status=>200, :json=> { message: "Willkommen, welcome, hai!" }
  end

  def health 
    render :status=>200, :json=> { message: "Willkommen, welcome, hai!" }
  end

  def ping
    render status: 200, json: {
      message: 'Oh hai' 
    }, callback: params[:callback]
  end
end
