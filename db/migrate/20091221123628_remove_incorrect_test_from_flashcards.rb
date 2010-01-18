class RemoveIncorrectTestFromFlashcards < ActiveRecord::Migration
  def self.up
    remove_column :flashcards, :incorrect_test
  end

  def self.down
    add_column :flashcards, :incorrect_test, :integer
  end
end
