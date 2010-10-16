class ChangeWidgetDataSetToReport < ActiveRecord::Migration
  def self.up
    rename_column :widgets, :data_set_id, :report_id
  end

  def self.down
    rename_column :widgets, :report_id, :data_set_id
  end
end
