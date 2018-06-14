# frozen_string_literal: true

class Api::V1::SplashFileUploadsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  def create
    if params[:splash_id]
      uploaded_io = params[:splash][:background_image_name]
      puts 88888888888888888888888888888888888
      puts uploaded_io.original_filename
      puts 88888888888888888888888888888888888

      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end
  end

  private

  def splash_params
    params.require(:splash).permit(:background_image_name, :header_image_name, :logo_file_name)
  end

end
