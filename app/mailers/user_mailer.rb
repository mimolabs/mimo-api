class UserMailer < ApplicationMailer
  # default from: 'notifications@example.com'
  default from: ENV['MIMO_DEFAULT_FROM_EMAIL'] || "no-reply@#{ENV['MIMO_SMTP_DOMAIN']}"
 
  def welcome_email
    @user = params[:user]
    @url  = "#{ENV['MIMO_DASHBOARD_URL']}/setup?code=#{params[:code]}"
    mail(to: @user.email, subject: 'Welcome to MIMO!')
  end
end
