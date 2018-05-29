# frozen_string_literal: true

namespace :production do
  desc 'Bootstrap the application'
  task bootstrap: :environment do
    puts 'xxxxxx BOOTSTRAPPING MIMO xxxxxx'

    f = '/etc/mimo/build.config.json'
    fw = '/etc/mimo/build.config.js'

    begin
      if File.exists?(f) 
        file  = File.read(f)
      else
        puts 'Using default config file from API'
        file = File.read(Rails.root.join('config/build.config.json'))
      end
    end

    data = JSON.parse file
    if ENV['INTERCOM_ID'].present?
      data['frontend']['constants']['INTERCOM'] = ENV['INTERCOM_ID']
    end

    if ENV['DRIFT_ID'].present?
      data['frontend']['constants']['DRIFT'] = ENV['DRIFT_ID']
    end

    if ENV['MIMO_API_URL'].blank?
      ENV['MIMO_API_URL'] = 'http://api:3000'
    end

    if ENV['MIMO_DASHBOARD_URL'].blank?
      ENV['MIMO_DASHBOARD_URL'] = 'http://mimo.dashboard:8080'
    end

    data['frontend']['constants']['API_END_POINT'] = ENV['MIMO_API_URL'] + '/api/v1'
    data['frontend']['constants']['API_URL'] = ENV['MIMO_API_URL']
    data['frontend']['constants']['AUTH_URL'] = ENV['MIMO_API_URL']

    data['callbackURL'] = ENV['MIMO_DASHBOARD_URL'] + '/auth/login/callback'
    data['authorizationURL'] = ENV['MIMO_API_URL'] + '/oauth/authorize'
    data['dashboardURL'] = ENV['MIMO_DASHBOARD_URL']
    data['profileURL'] = ENV['MIMO_API_URL'] + '/api/v1/me.json'
    data['tokenURL'] = ENV['MIMO_API_URL'] + '/oauth/token'

    puts 'xxxxxx CREATING ADMIN USER xxxxxx'
    password = SecureRandom.hex(6)
    email = ENV['MIMO_ADMIN_USER']

    admin = User.find_by role: 0
    unless admin.present?
      User.create! email: email, password: password, password_confirmation: password, admin: true, role: 2
      puts "User with email #{email} created with password #{password}. Please change this on your first login!"
    end

    puts 'xxxxxxx CREATING APPLICATION xxxxxx'
    app = Doorkeeper::Application.find_or_initialize_by(name: 'MIMO Standalone Client')
    if app.new_record?
      app.redirect_uri = "#{ENV['MIMO_DASHBOARD_URL']}/auth/login/callback"
      app.save!
    end

    # puts 'Application: '
    # puts "name: #{app.name}"
    # puts "redirect_uri: #{app.redirect_uri}"
    # puts "uid: #{app.uid}"
    # puts "secret: #{app.secret}"
    
    data['appID'] = app.uid
    data['appSecret'] = app.secret

    pretty = JSON.pretty_generate(data)
    pretty = "var opts = #{pretty} \n\nmodule.exports = opts"
    open(fw, 'w') { |f| f << pretty } 
  end
end
