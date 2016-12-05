class ChangeLatitudeAndLongitutdeToFloats < ActiveRecord::Migration
  def change
	change_table :posts do |t|
  		t.change :latitude, :float
  		t.change :longitude, :float
	end
  end
end
