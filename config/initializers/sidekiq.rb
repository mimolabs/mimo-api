rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = Rails.env || 'production'

require 'sidekiq'

sidekiq_config = YAML.load(ERB.new(File.read(rails_root + '/config/redis_server.yml')).result)

# Sidekiq.configure_server do |config|
#   config.redis = { :host => "#{sidekiq_config[rails_env]}"}
# end

Sidekiq.configure_client do |config|
  config.redis = { :host => "#{sidekiq_config[rails_env]}", port: ENV['REDIS_PORT'] || 6379 }
end
