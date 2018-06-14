class SplashHeaderUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fit: [851, 315]
  process convert: 'jpg'

  storage :file

  def store_dir
    "uploads/splash-images/#{model.id}"
  end

  def filename
    "header-image.jpg" if original_filename
  end

  def extension_whitelist
    %w(jpg jpeg gif png tif tiff)
  end
  
end