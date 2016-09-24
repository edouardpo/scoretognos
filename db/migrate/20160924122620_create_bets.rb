class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.references :user_score, index: true, foreign_key: true
      t.references :fixture, index: true, foreign_key: true
      t.references :points_gap, index: true, foreign_key: true
      t.integer :points

      t.timestamps null: false
    end
  end
end
