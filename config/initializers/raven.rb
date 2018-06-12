Raven.configure do |config|
  id = ENV['MIMO_SETTINGS_ID'] || Settings.first.try(:unique_id)
  return unless id.present?
  config.dsn = "https://mimo:user@errors.ldn-01.oh-mimo.com/#{id}"
end
