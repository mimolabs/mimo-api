# frozen_string_literal: true

class AddAudience < ActiveRecord::Migration[5.2]
  def change
    create_table :audiences do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'location_id'

      t.string :name, limit: 50
      t.text :predicates, array: true
      t.string :predicate_type, limit: 10
    end
  end
end
