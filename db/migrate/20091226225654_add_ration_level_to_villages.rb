class AddRationLevelToVillages < ActiveRecord::Migration
  def self.up
    add_column :villages, :ration_level, :string
  end

  def self.down
    remove_column :villages, :ration_level
  end
end
