class AddLocationUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :location_users do |t|
      t.string   'unique_id', limit: 64
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer :role_id
      t.integer :user_id
      t.integer :location_id
    end
  end
end
