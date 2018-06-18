class IncreasePopupImageCharLimit < ActiveRecord::Migration[5.2]
  def up
    change_column :splash_pages, :popup_image, :string, :limit => 30
  end

  def down
    change_column :splash_pages, :popup_image, :string, :limit => 10
  end
end
