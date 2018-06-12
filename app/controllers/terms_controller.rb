class TermsController < ApplicationController

  before_action :settings

  respond_to :html

  private

  def settings
    @settings = Settings.first
  end
end
