class CreateSplashIntegration < ActiveRecord::Migration[5.2]
  def change
    create_table :splash_integrations do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'

      t.string :api_token
      t.string :host
      t.string :integration_type,    limit: 10
      t.string :port,                limit: 5
      t.string :username,            limit: 26
      t.string :password,            limit: 26

      t.json :metadata,              default: {}
      t.boolean :active
    end
  end
end
