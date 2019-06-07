class AddLatLonToCrimes < ActiveRecord::Migration[5.2]
  def change
    add_column :crimes, :lat, :float
    add_column :crimes, :lon, :float
  end
end
