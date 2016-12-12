class RenameUserOrignIdToUserRemoteId < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :origin_user_id, :user_remote_id
  end
end
