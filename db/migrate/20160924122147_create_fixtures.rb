class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.references :day, index: true, foreign_key: true
      t.references :team_a, index: true
      t.references :team_b, index: true
      t.integer :score_a
      t.integer :score_b
      t.string :bonus_off
      t.string :bonus_def
      t.datetime :starts_at
      t.datetime :bets_start_at
      t.datetime :bets_end_at

      t.timestamps null: false
    end
  end
end
