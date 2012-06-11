class AddLatLngToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :latitude, :float, :null => true, :default => false
    add_column :addresses, :longitude, :float, :null => true, :default => false
  end
end
