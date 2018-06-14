class SplashBackgroundUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fit: [2400, 2400]
  process convert: 'jpg'

  storage :file

  def store_dir
    "uploads/splash-images/#{model.id}"
  end

  def filename
    "bg-image.jpg" if original_filename
  end

  def extension_whitelist
    %w(jpg jpeg gif png tif tiff)
  end
end