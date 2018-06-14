class SplashBackgroundUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fit: [2400, 2400]
  process convert: 'jpg'

  storage :file

  def store_dir
    "uploads/splash"
  end

  def filename
    "splash-bg-image-#{model.id}.jpg"
  end

  def extension_whitelist
    %w(jpg jpeg gif png tif tiff)
  end
end