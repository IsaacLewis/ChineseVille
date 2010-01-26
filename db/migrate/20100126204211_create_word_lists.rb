class CreateWordLists < ActiveRecord::Migration
  def self.up
    create_table :word_lists do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :word_lists
  end
end
