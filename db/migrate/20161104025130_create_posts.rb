class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :user
      t.string :latitude
      t.string :longitude
      t.text :content

      t.timestamps null: false
    end
  end
end
