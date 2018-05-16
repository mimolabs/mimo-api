class CreateTimelines < ActiveRecord::Migration[5.2]
  def change
    create_table :person_timelines do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'
      t.integer  :person_id

      t.string   :event, limit: 20
      t.json     :meta
    end
  end
end
