class RemoveUsersColumnFromPosts < ActiveRecord::Migration
  def change
  	remove_column :posts, :user
  end
end
