class ChangeForeignIdToFloatInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :foreign_id, :string
  end
end
