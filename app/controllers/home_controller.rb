# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to settings_path
  end
end
