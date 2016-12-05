class RenameUserColumn < ActiveRecord::Migration
  def change
  	rename_column :posts, :User_id, :user_id
  end
end
