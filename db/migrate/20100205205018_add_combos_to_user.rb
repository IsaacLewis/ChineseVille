class AddCombosToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :combos, :integer, :default => 0
  end

  def self.down
    remove_column :users, :combos
  end
end
