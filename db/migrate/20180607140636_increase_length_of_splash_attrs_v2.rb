class IncreaseLengthOfSplashAttrsV2 < ActiveRecord::Migration[5.2]
  def change
    change_column :splash_pages, :logo_file_name, :string, limit: 255
    change_column :splash_pages, :background_image_name, :string, limit: 255
    change_column :splash_pages, :location_image_name, :string, limit: 255
    change_column :splash_pages, :header_image_name, :string, limit: 255
    change_column :splash_pages, :btn_text, :string, limit: 100, default: 'Login Now'
    change_column :splash_pages, :reg_btn_text, :string, limit: 100, default: 'Register' 
    change_column :splash_pages, :password, :string, limit: 100
    change_column :splash_pages, :fb_page_id, :string, limit: 50
    change_column :splash_pages, :fb_app_id, :string, limit: 50
  end
end
