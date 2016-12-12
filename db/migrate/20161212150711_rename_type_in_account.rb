class RenameTypeInAccount < ActiveRecord::Migration[5.0]
  def change
    rename_column :accounts, :type, :account_type
    # rename_column :accounts, :status, :account_source
  end
end
