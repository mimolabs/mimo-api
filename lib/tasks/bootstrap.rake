# frozen_string_literal: true

namespace :production do
  desc 'Bootstrap the application'
  task bootstrap: :environment do
    puts 'xxxxxxxxxxxxxxxxxxxxx BOOTSTRAPPING MIMO xxxxxxxxxxxxxxxxxxxxx'
    puts 'xxxxxxxxxxxxxxxxxxxxx BOOTSTRAPPING MIMO xxxxxxxxxxxxxxxxxxxxx'
    puts ENV['REDIS_HOST']
  end

  desc 'Create the users'
  task create_admin: :environment do
    puts 'xxxxxxxxxxxxxxxxxxxxx CREATING ADMIN USER xxxxxxxxxxxxxxxxxxxxx'
    password = SecureRandom.hex(6)
    email = ENV['MIMO_ADMIN_USER']

    admin = User.find_by role: 2
    raise 'Admin user already present!!!!!!' if admin.present?

    User.create! email: email, password: password, password_confirmation: password, admin: true, role: 2
    puts "User with email #{email} created with password #{password}. Please change this on your first login!"
  end

  desc 'Create the application'
  task create_app: :environment do
    puts 'xxxxxxxxxxxxxxxxxxxxx CREATING APPLICATION xxxxxxxxxxxxxxxxxxxxx'
    app = Doorkeeper::Application.create! name: 'MIMO Standalone Client',
                                          redirect_uri: "#{ENV['MIMO_DASHBOARD_URL']}/auth/login/callback"
    puts 'Application: '
    puts "name: #{app.name}"
    puts "redirect_uri: #{app.redirect_uri}"
    puts "uid: #{app.uid}"
    puts "secret: #{app.secret}"
    puts ''
  end
end
