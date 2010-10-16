class RemoveUnneededColumnsFromDataSets < ActiveRecord::Migration
  def self.up
    remove_column :data_sets, :config
    remove_column :data_sets, :data
  end

  def self.down
    add_column :data_sets, :data, :text
    add_column :data_sets, :config, :text
  end
end
