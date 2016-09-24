class AddStatusToDay < ActiveRecord::Migration
  def change
    add_column :days, :status, :string
    add_column :days, :name, :string
  end
end
