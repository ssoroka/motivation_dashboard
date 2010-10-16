class ChangeIntegrationToIntegrationIdOnDataSources < ActiveRecord::Migration
  def self.up
    rename_column :data_sources, :integration, :integration_id
    change_column :data_sources, :integration_id, :integer
  end

  def self.down
    rename_column :data_sources, :integration_id, :integration
    change_column :data_sources, :integration, :string
  end
end
