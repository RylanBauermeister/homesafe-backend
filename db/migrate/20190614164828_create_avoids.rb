class CreateAvoids < ActiveRecord::Migration[5.2]
  def change
    create_table :avoids do |t|
      t.float :lat
      t.float :lng
      t.string :notes

      t.timestamps
    end
  end
end
