class AddFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string, limit: 50
    add_column :users, :timezone, :string, limit: 26
    add_column :users, :country, :string, limit: 26
    add_column :users, :account_id, :string, limit: 10
    add_column :users, :slug, :string
    add_column :users, :locale, :string, limit: 2
    add_column :users, :radius_secret, :string
    add_column :users, :alerts_window_start, :string, limit: 5
    add_column :users, :alerts_window_end, :string, limit: 5
    add_column :users, :alerts_window_days, :text, :array => true
    add_column :users, :alerts, :boolean, default: true
  end
end
