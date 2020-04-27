class AddColumnsToPosts < ActiveRecord::Migration[5.1]
  def up
    add_column :posts, :started_at, :datetime
    add_column :posts, :ended_at, :datetime
  end
  
  def down
    remove_column :posts, :started_at, :datetime
    remove_column :posts, :ended_at, :datetime
  end
end
