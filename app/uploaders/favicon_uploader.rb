class FaviconUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads"
  end

  # process :resize_to_fit => [200, 200]

  def extension_whitelist
    %w(ico)
  end

  def filename
    "favicon.ico" if original_filename
  end
end
