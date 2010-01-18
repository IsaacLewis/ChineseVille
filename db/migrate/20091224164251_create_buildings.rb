class CreateBuildings < ActiveRecord::Migration
  def self.up
    create_table :buildings do |t|
      t.integer :village_id
      t.integer :type_id
      t.integer :number

      t.timestamps
    end
  end

  def self.down
    drop_table :buildings
  end
end
