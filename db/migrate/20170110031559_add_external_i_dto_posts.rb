class AddExternalIDtoPosts < ActiveRecord::Migration
  def change
  	  	add_column :posts, :external_id, :string
  end
end
