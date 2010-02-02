class ChangeFbuiDsToBigInt < ActiveRecord::Migration
  def self.up
    change_column :users, :facebook_id, :bigint
  end

  def self.down
    change_column :users, :facebook_id, :integer
  end
end
