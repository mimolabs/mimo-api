Raven.configure do |config|
  return if Rails.env.test?
  id = ENV['MIMO_SETTINGS_ID'] || Settings.first.try(:unique_id)
  return unless id.present?
  # config.dsn = "https://mimo:user@errors.ldn-01.oh-mimo.com/#{id}"
  config.dsn = "http://mimo:user@errors.ldn-01.oh-mimo.com:3000/#{id}"
end
