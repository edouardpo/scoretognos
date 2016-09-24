class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.references :championship, index: true, foreign_key: true
      t.datetime :date

      t.timestamps null: false
    end
  end
end
