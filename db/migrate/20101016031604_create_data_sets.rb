class CreateDataSets < ActiveRecord::Migration
  def self.up
    create_table :data_sets do |t|
      t.text :config
      t.text :data
      t.references :data_source

      t.timestamps
    end
    add_index :data_sets, :data_source_id
  end

  def self.down
    drop_table :data_sets
  end
end
