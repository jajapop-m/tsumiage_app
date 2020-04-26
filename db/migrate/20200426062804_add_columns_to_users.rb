class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :profile, :text
    add_column :users, :image_name, :string
  end
  
  def down
    remove_column :users, :profile
    remove_column :users, :image_name
  end
end
