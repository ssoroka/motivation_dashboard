class AddConfigToDataSets < ActiveRecord::Migration
  def self.up
    add_column :data_sets, :config, :text
  end

  def self.down
    remove_column :data_sets, :config
  end
end
