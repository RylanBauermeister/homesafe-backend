class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.integer :lat
      t.integer :lng
      t.string :notes

      t.timestamps
    end
  end
end
