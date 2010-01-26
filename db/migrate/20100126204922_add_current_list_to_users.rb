class AddCurrentListToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :current_list, :integer
  end

  def self.down
    remove_column :users, :current_list
  end
end
