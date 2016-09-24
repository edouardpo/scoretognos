class CreatePointsGaps < ActiveRecord::Migration
  def change
    create_table :points_gaps do |t|
      t.integer :bottom
      t.integer :top
      t.boolean :active

      t.timestamps null: false
    end
  end
end
