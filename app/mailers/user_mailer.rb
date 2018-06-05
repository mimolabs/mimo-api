class UserMailer < ApplicationMailer
  # default from: 'notifications@example.com'
  default from: ENV['MIMO_DEFAULT_FROM_EMAIL'] || "no-reply@#{ENV['MIMO_SMTP_DOMAIN']}"
 
  def new_code 
    @user = params[:user]
    @url  = "#{ENV['MIMO_DASHBOARD_URL']}/wizard/start?code=#{generate_code}"
    mail(to: @user.email, subject: 'New setup code!')
  end

  def welcome_email
    @user = params[:user]
    @url  = "#{ENV['MIMO_DASHBOARD_URL']}/wizard/start?code=#{generate_code}"
    mail(to: @user.email, subject: 'Welcome to MIMO!')
  end

  def generate_code
    code = SecureRandom.uuid
    REDIS.setex code, 86400, 1
    code
  end
end
