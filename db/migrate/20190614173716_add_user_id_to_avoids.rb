class AddUserIdToAvoids < ActiveRecord::Migration[5.2]
  def change
    add_column :avoids, :user_id, :integer
  end
end
