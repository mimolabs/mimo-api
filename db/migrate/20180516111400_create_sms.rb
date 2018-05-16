class CreateSms < ActiveRecord::Migration[5.2]
  def change
    create_table :sms do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'

      t.string :number, limit: 15
      t.integer :person_id
      t.string :client_mac, limit: 18
    end
  end
end
