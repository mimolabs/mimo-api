class EventLog < ActiveRecord::Migration[5.2]
  def change
    create_table :event_logs do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer :location_id
      t.string :resource_id, limit: 10
      t.json :meta
      t.json :data
      t.json :response
      t.string :event_type, limit: 12
    end
  end
end
