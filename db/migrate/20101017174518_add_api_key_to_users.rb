class AddApiKeyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :api_key, :string
    User.all.each do |user|
      user.set_api_key
      user.save
    end
  end

  def self.down
    remove_column :users, :api_key
  end
end
