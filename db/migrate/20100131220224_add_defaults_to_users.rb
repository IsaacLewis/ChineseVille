class AddDefaultsToUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :energy, :integer, :default => 0
    change_column :users, :food, :integer, :default => 0
  end

  def self.down
    change_column :users, :energy, :integer
    change_column :users, :food, :integer
  end
end
