# frozen_string_literal: true

class CreateLocation < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string   'unique_id', limit: 64
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string   'location_name',            limit: 255
      t.string   'location_address',         limit: 255
      t.string   'town',                     limit: 255
      t.string   'street',                   limit: 255
      t.string   'postcode',                 limit: 255
      t.string   'country',                  limit: 255, default: 'United Kingdom'
      t.string   'owner',                    limit: 255
      t.string   'website',                  limit: 255
      t.string   'geocode',                  limit: 255
      t.string   'phone1',                   limit: 255
      t.integer  'user_id',                  limit: 4
      t.string   'api_token',                limit: 255
      t.string   'slug',                     limit: 255
      t.float    'latitude',                 limit: 24
      t.float    'longitude',                limit: 24
      t.boolean  'has_devices',                               default: false
      t.string   'timezone',                 limit: 255,      default: 'Europe/London'
      t.integer  'lucky_dip',                limit: 4
      t.string   'category',                 limit: 50
      t.boolean  'demo',                     default: true
      t.boolean  'eu',                       default: true
      t.boolean  'paid',                     default: false
    end

    add_index 'locations', ['slug'], name: 'index_locations_on_slug', unique: true, using: :btree
  end
end
