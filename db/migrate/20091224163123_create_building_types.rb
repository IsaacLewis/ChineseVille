class CreateBuildingTypes < ActiveRecord::Migration
  def self.up
    create_table :building_types do |t|
      t.string :name
      t.string :description
      t.string :type
      t.integer :effect

      t.timestamps
    end
  end

  def self.down
    drop_table :building_types
  end
end
