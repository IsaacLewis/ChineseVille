class RenameUserListColumn < ActiveRecord::Migration
  def self.up
    rename_column :users, :current_list, :current_list_id
  end

  def self.down
    rename_column :users, :current_list_id, :current_list
  end
end
