class AddUserInterests < ActiveRecord::Migration
  def self.up
    add_column :users, :interests, :text
  end

  def self.down
    remove_column :users, :interests
  end
end
