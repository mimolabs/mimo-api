class CreateSplashPages < ActiveRecord::Migration[5.2]
  def change
    create_table :splash_pages do |t|
      t.string   "unique_id",                limit: 64
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
