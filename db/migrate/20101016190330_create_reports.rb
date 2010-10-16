class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :report_type_id
      t.integer :data_set_id
      t.text :config
      t.text :data

      t.timestamps
    end
    add_index :reports, :data_set_id
  end

  def self.down
    drop_table :reports
  end
end
