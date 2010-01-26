class ChangeFlashcardDueToDateTime < ActiveRecord::Migration
  def self.up
    change_column :flashcards, :next_due, :datetime
  end

  def self.down
    change_column :flashcards, :next_due, :time
  end
end
