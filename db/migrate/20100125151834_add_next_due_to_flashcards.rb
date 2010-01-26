class AddNextDueToFlashcards < ActiveRecord::Migration
  def self.up
    add_column :flashcards, :next_due, :time
  end

  def self.down
    remove_column :flashcards, :next_due
  end
end
