class RenameTypeInAccount < ActiveRecord::Migration[5.0]
  def change
    rename_column :accounts, :type, :account_type
  end
end
