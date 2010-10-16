class AddIngregrationToDataSources < ActiveRecord::Migration
  def self.up
    add_column :data_sources, :integration, :string
  end

  def self.down
    remove_column :data_sources, :integration
  end
end
