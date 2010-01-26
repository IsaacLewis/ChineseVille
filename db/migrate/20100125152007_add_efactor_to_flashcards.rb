class AddEfactorToFlashcards < ActiveRecord::Migration
  def self.up
    add_column :flashcards, :efactor, :decimal
  end

  def self.down
    remove_column :flashcards, :efactor
  end
end
