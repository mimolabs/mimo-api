class CreateSenders < ActiveRecord::Migration[5.2]
  def change
    create_table :senders do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'

      t.integer  'location_id'
      t.integer :user_id     

      t.string :sender_name,     limit: 50
      t.string :sender_type,     limit: 50
      t.string :from_name,       limit: 50
      t.string :from_email,      limit: 50
      t.string :from_sms,        limit: 50
      t.string :from_twitter,    limit: 50
      t.string :twitter_token,   limit: 50
      t.string :twitter_secret,  limit: 50
      t.string :reply_email,     limit: 50
      t.string :address,         limit: 50
      t.string :town,            limit: 50
      t.string :postcode,        limit: 50
      t.string :country,         limit: 50
      t.string :token,           limit: 50

      t.boolean :is_validated
    end
  end
end
