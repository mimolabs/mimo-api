class CreateBoxes < ActiveRecord::Migration[5.2]
  def change
    create_table :boxes do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'
      t.string :mac_address, limit: 18
      t.string :state, limit: 10
      t.string :machine_type, limit: 26
      t.text :description
      t.datetime :last_heartbeat
    end
  end
end
