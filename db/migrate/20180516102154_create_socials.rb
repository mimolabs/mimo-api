class CreateSocials < ActiveRecord::Migration[5.2]
  def change
    create_table :socials do |t|
      t.string   'unique_id', limit: 64
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'

      t.string :facebook_id,        limit: 24
      t.string :google_id,          limit: 24
      t.string :tw_profile_image,   limit: 24
      t.string :email,              limit: 50
      t.string :first_name,         limit: 24
      t.string :last_name,          limit: 24
      t.string :gender,             limit: 6
      t.string :fb_username,        limit: 24
      t.string :fb_link,            limit: 24
      t.string :fb_full_name,        limit: 24
      t.string :fb_current_location, limit: 24
      t.string :g_link,              limit: 24
      t.string :g_image_url
      t.string :g_etag,             limit: 24
      t.string :g_full_name,        limit: 24
      t.string :g_urrent_location,  limit: 24
      t.string :current_location,    limit: 24
      t.string :twitter_id,         limit: 24
      t.string :tw_full_name,       limit: 24
      t.string :tw_screen_name,     limit: 24
      t.string :tw_description,     limit: 24
      t.string :tw_url

      t.integer :person_id
      t.integer :tw_followers       
      t.integer :tw_friends         
      t.integer :checkins          
      
      t.text :location_ids,      array: true
      t.text :splash_ids,        array: true
      t.text :emails,            array: true
      t.text :clientMacs,        array: true
      t.text :client_ids,        array: true
      t.text :gOrganisations,    array: true
      t.text :networks,          array: true
      t.text :lonlat,            array: true
      t.text :locations,         array: true

      t.boolean :tw_verified
      t.boolean :newsletter,     default: false
    end
  end
end
