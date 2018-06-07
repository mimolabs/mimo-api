class IncreaseLengthOfSplashAttrs < ActiveRecord::Migration[5.2]
  def change
    change_column :splash_pages, :header_colour,                    :string, default: '#FFFFFF', limit: 30
    change_column :splash_pages, :button_colour,                    :string, default: '#FFFFFF', limit: 30
    change_column :splash_pages, :button_border_colour,             :string, default: '#000',    limit: 30
    change_column :splash_pages, :container_colour,                 :string, default: '#FFFFFF', limit: 30
    change_column :splash_pages, :body_background_colour,           :string, default: '#FFFFFF', limit: 30
    change_column :splash_pages, :heading_text_colour,              :string, default: '#000000', limit: 30
    change_column :splash_pages, :heading_2_text_colour,            :string, default: '#000000', limit: 30
    change_column :splash_pages, :heading_3_text_colour,            :string, default: '#000000', limit: 30
    change_column :splash_pages, :body_text_colour,                 :string, default: '#333333', limit: 30
    change_column :splash_pages, :border_colour,                    :string, default: '#CCCCCC', limit: 30
    change_column :splash_pages, :btn_font_colour,                  :string, default: '#000000', limit: 30
    change_column :splash_pages, :link_colour,                      :string, default: '#2B68B6', limit: 30
    change_column :splash_pages, :error_colour,                     :string, default: '#ED561B', limit: 30
    change_column :splash_pages, :email_button_colour,              :string, default: 'rgb(255, 255, 255)', limit: 30
    change_column :splash_pages, :email_button_border_colour,       :string, default: 'rgb(204, 204, 204)', limit: 30
    change_column :splash_pages, :email_btn_font_colour,            :string, default: 'rgb(0, 0, 0)', limit: 30
    change_column :splash_pages, :sms_button_colour,                :string, default: 'rgb(239, 83, 80)', limit: 30
    change_column :splash_pages, :sms_button_border_colour,         :string, default: 'rgba(239, 83, 80, 0)', limit: 30
    change_column :splash_pages, :sms_btn_font_colour,              :string, default: 'rgb(255, 255, 255)', limit: 30
    change_column :splash_pages, :voucher_button_colour,            :string, default: 'rgb(255, 255, 255)', limit: 30
    change_column :splash_pages, :voucher_button_border_colour,     :string, default: 'rgb(204, 204, 204)', limit: 30
    change_column :splash_pages, :voucher_btn_font_colour,          :string, default: 'rgb(0, 0, 0)', limit: 30
    change_column :splash_pages, :codes_button_colour,              :string, default: 'rgb(255, 255, 255)', limit: 30
    change_column :splash_pages, :codes_button_border_colour,       :string, default: 'rgb(204, 204, 204)', limit: 30
    change_column :splash_pages, :codes_btn_font_colour,            :string, default: 'rgb(0, 0, 0)', limit: 30
    change_column :splash_pages, :password_button_colour,           :string, default: 'rgb(255, 255, 255)', limit: 30
    change_column :splash_pages, :password_button_border_colour,    :string, default: 'rgb(204, 204, 204)', limit: 30
    change_column :splash_pages, :password_btn_font_colour,         :string, default: 'rgb(0, 0, 0)', limit: 30
    change_column :splash_pages, :input_border_colour,              :string, default: '#d0d0d0', limit: 30
    change_column :splash_pages, :input_background,                 :string, default: '#FFFFFF', limit: 30
    change_column :splash_pages, :input_text_colour,                :string, default: '#3D3D3D', limit: 30
    change_column :splash_pages, :footer_text_colour,               :string, default: '#CCC', limit: 30
    change_column :splash_pages, :popup_background_colour,          :string, default: 'rgb(255,255,255)', limit: 30
  end
end
