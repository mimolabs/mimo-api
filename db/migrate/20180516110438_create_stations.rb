class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'

      t.string :ssid, 36
      t.string :client_mac, 18
    end
  end
end
