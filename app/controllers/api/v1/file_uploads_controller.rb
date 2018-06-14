# frozen_string_literal: true

class Api::V1::FileUploadsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  def create
    if params[:splash_id]
      puts 88888888888888888888888888888888888
      puts 88888888888888888888888888888888888
      puts 88888888888888888888888888888888888
      puts 88888888888888888888888888888888888
      puts params[:splash]
      puts 88888888888888888888888888888888888
      puts 88888888888888888888888888888888888
      puts 88888888888888888888888888888888888
      puts 88888888888888888888888888888888888
      # @splash_page = SplashPage.find_by(id: params[:splash_id])
      # authorize @splash_page, :update?
      # @splash_page.update(splash_params)
    end
  end

  private

  def splash_params
    params.require(:splash).permit(:background_image_name, :header_image_name, :logo_file_name)
  end

end
