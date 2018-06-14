# frozen_string_literal: true

class Api::V1::FileUploadsController < Api::V1::BaseController

  def create
    @splash = SplashPage.find_by(id: params[:splash_id])
    @splash.update(splash_params)
  end

  private

  def splash_params
    params.require(:splash).permit(:background_image_name, :header_image_name, :logo_file_name)
  end

end
