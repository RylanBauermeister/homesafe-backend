class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.integer :foreign_id
      t.json :crime_weights

      t.timestamps
    end
  end
end
