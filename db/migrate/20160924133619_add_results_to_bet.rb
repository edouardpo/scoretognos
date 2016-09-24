class AddResultsToBet < ActiveRecord::Migration
  def change
    add_column :bets, :result, :string
    add_column :bets, :bonus_off, :string
    add_column :bets, :bonus_def, :string
  end
end
