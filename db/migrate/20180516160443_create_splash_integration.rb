class CreateSplashIntegration < ActiveRecord::Migration[5.2]
  def change
    create_table :splash_integrations do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'

      t.string :api_token,           limit: 50
      t.string :host,                limit: 50
      t.string :type,                limit: 50
      t.string :port,                limit: 50
      t.string :username,            limit: 50
      t.string :password,            limit: 50

      t.json :metadata,              default: {}
      t.boolean :active
    end
  end
end
