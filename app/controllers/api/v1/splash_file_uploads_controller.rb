# frozen_string_literal: true

class Api::V1::SplashFileUploadsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  def create
    if params[:splash_id]
      splash = SplashPage.find_by(id: params[:splash_id])
      authorize splash, :update?
      uploaded_io = set_file
      if @file_name
        File.open(Rails.root.join('public', 'uploads', @file_name), 'wb') do |file|
          file.write(uploaded_io.read)
        end
      end
    end
  end

  private

  def set_file
    if params[:splash][:background_image]
      @file_name = "bg-image-#{params[:splash_id]}.jpg"
      params[:splash][:background_image]
    elsif params[:splash][:logo_file]
      @file_name = "logo-image-#{params[:splash_id]}.jpg"
      params[:splash][:logo_file]
    elsif params[:splash][:header_image]
      @file_name = "header-image-#{params[:splash_id]}.jpg"
      params[:splash][:header_image]
    end
  end

  def splash_params
    params.require(:splash).permit(:background_image, :header_image, :logo_file)
  end

end
