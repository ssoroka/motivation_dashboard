class AddNextPollAtToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :next_poll_at, :datetime
    add_index :users, :next_poll_at
  end

  def self.down
    remove_index :users, :next_poll_at
    remove_column :users, :next_poll_at
  end
end
