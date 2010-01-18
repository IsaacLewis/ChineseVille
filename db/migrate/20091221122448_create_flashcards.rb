class CreateFlashcards < ActiveRecord::Migration
  def self.up
    create_table :flashcards do |t|
      t.integer :word_id
      t.integer :user_id
      t.integer :knowledge_chance
      t.integer :correct_tests
      t.integer :incorrect_test

      t.timestamps
    end
  end

  def self.down
    drop_table :flashcards
  end
end
