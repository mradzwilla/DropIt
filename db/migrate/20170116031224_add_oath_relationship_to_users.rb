class AddOathRelationshipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oath_relationship, :boolean
  end
end
