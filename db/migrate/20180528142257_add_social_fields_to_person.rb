class AddSocialFieldsToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :facebook, :boolean, default: false
    add_column :people, :google, :boolean, default: false
    add_column :people, :twitter, :boolean, default: false
  end
end
