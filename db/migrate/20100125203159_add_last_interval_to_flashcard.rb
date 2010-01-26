class AddLastIntervalToFlashcard < ActiveRecord::Migration
  def self.up
    add_column :flashcards, :last_interval, :integer
  end

  def self.down
    remove_column :flashcards, :last_interval
  end
end
