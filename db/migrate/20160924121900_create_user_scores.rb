class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.references :user, index: true, foreign_key: true
      t.references :championship, index: true, foreign_key: true
      t.integer :value, default: 0

      t.timestamps null: false
    end
  end
end
