class ChangeFlashcardDefaults < ActiveRecord::Migration
  def self.up
    change_column :flashcards, :correct_tests, :integer, :default => 0
    change_column :flashcards, :incorrect_tests, :integer, :default => 0
    change_column :flashcards, :knowledge_chance, :integer, :default => 0
  end

  def self.down
    change_column :flashcards, :correct_tests, :integer
    change_column :flashcards, :incorrect_tests, :integer
    change_column :flashcards, :knowledge_chance, :integer
  end
end
