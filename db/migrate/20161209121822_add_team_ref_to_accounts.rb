class AddTeamRefToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_reference :accounts, :team, foreign_key: true
  end
end
