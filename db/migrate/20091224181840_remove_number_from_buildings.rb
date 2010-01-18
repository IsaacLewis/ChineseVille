class RemoveNumberFromBuildings < ActiveRecord::Migration
  def self.up
    remove_column :buildings, :number
    remove_column :building_types, :type
  end

  def self.down
    add_column :buildings, :number, :integer
    add_column :building_types, :type, :string
  end
end
