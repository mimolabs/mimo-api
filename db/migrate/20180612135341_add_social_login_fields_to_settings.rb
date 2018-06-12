class AddSocialLoginFieldsToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :splash_twilio_user, :string
    add_column :settings, :splash_twilio_pass, :string
    add_column :settings, :splash_twitter_consumer_key, :string
    add_column :settings, :splash_twitter_consumer_secret, :string
    add_column :settings, :splash_google_client_id, :string
    add_column :settings, :splash_google_client_secret, :string
    add_column :settings, :splash_facebook_client_id, :string
    add_column :settings, :splash_facebook_client_secret, :string
  end
end
