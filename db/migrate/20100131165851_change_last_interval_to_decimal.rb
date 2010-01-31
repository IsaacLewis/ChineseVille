class ChangeLastIntervalToDecimal < ActiveRecord::Migration
  def self.up
    change_column :flashcards, :last_interval, :decimal
  end

  def self.down
    change_column :flashcards, :last_interval, :integer
  end
end
