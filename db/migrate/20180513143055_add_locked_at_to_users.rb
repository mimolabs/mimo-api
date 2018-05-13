class AddLockedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :locked_at, :time
  end
end
