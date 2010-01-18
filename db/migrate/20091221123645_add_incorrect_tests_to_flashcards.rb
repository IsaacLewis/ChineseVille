class AddIncorrectTestsToFlashcards < ActiveRecord::Migration
  def self.up
    add_column :flashcards, :incorrect_tests, :integer
  end

  def self.down
    remove_column :flashcards, :incorrect_tests
  end
end
