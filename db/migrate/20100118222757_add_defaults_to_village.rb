class AddDefaultsToVillage < ActiveRecord::Migration
  def self.up
    change_column :villages, :ration_level, :string, :default => 'normal'
    change_column :villages, :population, :integer, :default => 1
  end

  def self.down
    change_column :villages, :ration_level, :string, :default => nil
    change_column :villages, :population, :integer, :default => nil
  end
end
