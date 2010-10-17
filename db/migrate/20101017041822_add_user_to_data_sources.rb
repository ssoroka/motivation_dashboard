class AddUserToDataSources < ActiveRecord::Migration
  def self.up
    add_column :data_sources, :user_id, :integer
    add_index :data_sources, :user_id
  end

  def self.down
    remove_index :data_sources, :user_id
    remove_column :data_sources, :user_id
  end
end
