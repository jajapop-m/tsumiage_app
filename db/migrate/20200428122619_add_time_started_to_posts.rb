class AddTimeStartedToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :time_started, :boolean, default: false
  end
end
