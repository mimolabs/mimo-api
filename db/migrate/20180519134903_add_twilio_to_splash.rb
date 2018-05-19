class AddTwilioToSplash < ActiveRecord::Migration[5.2]
  def change
    add_column :splash_pages, :twilio_user, :string, limit: 50
    add_column :splash_pages, :twilio_pass, :string, limit: 50
  end
end
