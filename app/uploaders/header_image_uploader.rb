class HeaderImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/splash-images/#{model.id}"
  end

  def filename
    "header-image.jpg" if original_filename
  end

  private

  # def efficient_conversion(width, height)

  # end
end