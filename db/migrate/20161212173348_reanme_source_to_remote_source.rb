class ReanmeSourceToRemoteSource < ActiveRecord::Migration[5.0]
  def change
    rename_column :accounts, :source, :remote_source
  end
end
