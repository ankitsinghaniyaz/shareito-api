class ChangeDataTypeForSourceId < ActiveRecord::Migration[5.0]
  def change
    change_column :accounts, :source_id, :string
  end
end
