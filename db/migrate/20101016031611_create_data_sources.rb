class CreateDataSources < ActiveRecord::Migration
  def self.up
    create_table :data_sources do |t|
      t.text :config
      t.string :api_key
      t.timestamps
    end
    add_index :data_sources, :api_key
  end

  def self.down
    drop_table :data_sources
  end
end
