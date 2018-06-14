class SplashLogoUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/splash-images/#{model.id}"
  end

  def filename
    "logo-image.jpg" if original_filename
  end

  def extension_whitelist
    %w(jpg jpeg gif png bmp tif tiff)
  end

  private

  # def efficient_conversion(width, height)

  # end
end