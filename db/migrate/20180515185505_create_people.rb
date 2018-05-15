class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string   "unique_id",                limit: 64
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  'location_id'

      t.integer :login_count

      t.string :campaign_id, limit: 26
      t.string :client_mac, limit: 26
      t.string :username, limit: 26
      t.string :email, limit: 50
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.string :google_id, limit: 26

      t.boolean :consented, default: true
      t.boolean :unsubscribed, default: false

      t.text :campaign_ids, array: true
      t.datetime :last_seen
    end
  end
end
