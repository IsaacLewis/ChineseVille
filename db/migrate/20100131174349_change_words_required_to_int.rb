class ChangeWordsRequiredToInt < ActiveRecord::Migration
  def self.up
     change_column :building_types, :words_required, :integer
  end

  def self.down
     change_column :building_types, :words_required, :string
  end
end
