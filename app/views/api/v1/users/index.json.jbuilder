# frozen_string_literal: true

json.id @user.id
json.username @user.username
json.created_at @user.created_at.to_i
json.email @user.email
json.timezone @user.timezone
json.country @user.country
json.account_id @user.account_id
json.last_sign_in_at @user.last_sign_in_at
json.last_sign_in_ip @user.last_sign_in_ip
json.slug @user.slug
json.locale @user.locale
json.alerts @user.alerts
json.alerts_window_start @user.alerts_window_start # .to_i
json.alerts_window_end @user.alerts_window_end
json.alerts_window_days @user.alerts_window_days
json.radius_secret @user.radius_secret
