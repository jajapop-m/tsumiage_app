class AddPostIdToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :post_id, :integer
    
    add_index :posts, :post_id
  end
end
