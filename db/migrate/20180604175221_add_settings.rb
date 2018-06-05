class AddSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.datetime :created_at
      t.datetime :updated_at

      t.string :unique_id, limit: 64
      t.string :business_name
      t.string :locale, :default => 'en', limit: 4
      t.string :docs_url
      t.string :contact_url
      t.string :terms_url
      t.string :from_email
      t.string :logo
      t.string :favicon
      t.string :intercom_id, limit: 16
      t.string :drift_id, limit: 16
      t.boolean :invite_admins, default: false
      t.boolean :invite_users, default: false
    end
  end
end
