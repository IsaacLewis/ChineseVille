class AddCostToBuildingTypes < ActiveRecord::Migration
  def self.up
    add_column :building_types, :cost, :integer
  end

  def self.down
    remove_column :building_types, :cost
  end
end
