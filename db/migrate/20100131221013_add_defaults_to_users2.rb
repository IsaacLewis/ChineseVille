class AddDefaultsToUsers2 < ActiveRecord::Migration
  def self.up
    change_column :users, :energy, :integer, :default => 20
    change_column :users, :food, :integer, :default => 0
  end

  def self.down
    change_column :users, :energy, :integer, :default => 0
    change_column :users, :food, :integer, :default => 0
  end
end
