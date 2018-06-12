class AddFieldsToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :business_address, :string
  end
end
