Raven.configure do |config|
  return if Rails.env.test?
  id = ENV['MIMO_SETTINGS_ID'] || Settings.first.try(:unique_id)
  return unless id.present?
  config.dsn = "https://mimo:user@stats-sink.oh-mimo.com/#{id}"
end
