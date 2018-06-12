class SplashLinkedIn < ActiveRecord::Migration[5.2]
  def change
    add_column :splash_pages, :linkedin_name, :string, :limit => 100
    add_column :splash_pages, :instagram_name, :string, :limit => 100
    add_column :splash_pages, :pinterest_name, :string, :limit => 100
  end
end
