class AddDefaultsToFlashcard < ActiveRecord::Migration
  def self.up
    change_column :flashcards, :efactor, :decimal, :default => 2.5
  end

  def self.down
    change_column :flashcards, :efactor, :decimal
  end
end
