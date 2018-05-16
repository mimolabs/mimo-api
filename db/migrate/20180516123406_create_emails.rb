class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'
      t.integer :person_id

      t.integer :station_id

      t.string :email,               limit: 100
      t.string :comments,            limit: 50
      t.string :splash_id,           limit: 50
      t.string :list_id,             limit: 50
      t.string :list_type,           limit: 50

      t.boolean :added,              default: false
      t.boolean :active,             default: true
      t.boolean :blocked
      t.boolean :bounced             
      t.boolean :spam              
      t.boolean :unsubscribed        
      t.boolean :consented,          default: false

      t.text :macs,                array: true
      t.text :lists,               array: true
    end
  end
end
