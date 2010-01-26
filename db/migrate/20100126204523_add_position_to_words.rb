class AddPositionToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :position, :integer
  end

  def self.down
    remove_column :words, :position
  end
end
