class CreateDashboard < ActiveRecord::Migration
  def self.up
    create_table :dashboards do |t|
      t.string :name, :default => 'Motivation Dashboard'
      t.references :user
      t.timestamps
    end
    add_index :dashboards, :user_id
  end

  def self.down
    drop_table :dashboards
  end
end
