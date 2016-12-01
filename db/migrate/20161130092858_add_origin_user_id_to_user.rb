class AddOriginUserIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :origin_user_id, :string
  end
end
