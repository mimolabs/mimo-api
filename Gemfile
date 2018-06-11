# frozen_string_literal: true

source 'http://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.0'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 4.0'
gem 'uglifier', require: 'uglifier'
gem 'devise'
gem 'doorkeeper'
gem 'friendly_id', git: 'https://github.com/norman/friendly_id.git'
#gem 'raven-ruby', git: 'https://github.com/mimolabs/raven-ruby.git'
gem 'kaminari'
gem 'pundit'
gem 'rack-cors', require: 'rack/cors'
gem 'faraday', '0.15.1'
gem 'mustache'
gem 'rails-i18n'
gem 'sidekiq'
gem 'haml'
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'sdoc'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_bot'
  gem 'faker'
  gem 'fakeredis'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.7'
  gem 'vcr'
  gem 'webmock'
end
