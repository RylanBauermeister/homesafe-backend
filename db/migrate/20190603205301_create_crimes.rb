class CreateCrimes < ActiveRecord::Migration[5.2]
  def change
    create_table :crimes do |t|
      t.integer :caseId
      t.string :calltype
      t.string :callcategory
      t.string :addressblock
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
