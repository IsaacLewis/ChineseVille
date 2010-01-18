class AddBonusTypeToBuildingType < ActiveRecord::Migration
  def self.up
    add_column :building_types, :bonus_type, :string
  end

  def self.down
    remove_column :building_types, :bonus_type
  end
end
