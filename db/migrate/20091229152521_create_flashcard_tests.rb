class CreateFlashcardTests < ActiveRecord::Migration
  def self.up
    create_table :flashcard_tests do |t|
      t.integer :flashcard_id
      t.integer :answer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :flashcard_tests
  end
end
