class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads"
  end

  process :resize_to_fit => [200, 200]

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [120, 120]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "square-logo.png" if original_filename
  end
end
