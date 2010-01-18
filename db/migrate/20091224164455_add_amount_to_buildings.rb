class AddAmountToBuildings < ActiveRecord::Migration
  def self.up
    add_column :buildings, :amount, :integer
  end

  def self.down
    remove_column :buildings, :amount
  end
end
