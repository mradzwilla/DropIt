class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.datetime :created_at
      t.datetime :updated_at
      t.string :profile_page

      t.timestamps null: false
    end
  end
end
