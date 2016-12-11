class AddSourceIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :source_id, :integer
  end
end
