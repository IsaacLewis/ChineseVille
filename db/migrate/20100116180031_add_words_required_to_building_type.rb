class AddWordsRequiredToBuildingType < ActiveRecord::Migration
  def self.up
    add_column :building_types, :words_required, :string
  end

  def self.down
    remove_column :building_types, :words_required
  end
end
