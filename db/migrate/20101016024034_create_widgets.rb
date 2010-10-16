class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|
      t.references :dashboard
      t.integer :position
      t.integer :widget_size, :default => 1
      t.references :data_set
      t.references :widget_type
      t.timestamps
    end
    add_index :widgets, :data_set_id
    add_index :widgets, :dashboard_id
  end

  def self.down
    drop_table :widgets
  end
end
