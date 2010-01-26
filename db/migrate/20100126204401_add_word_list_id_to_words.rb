class AddWordListIdToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :word_list_id, :integer
  end

  def self.down
    remove_column :words, :word_list_id
  end
end
