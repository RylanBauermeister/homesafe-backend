class AddCategoryToCrimes < ActiveRecord::Migration[5.2]
  def change
    add_column :crimes, :category, :string
  end
end
