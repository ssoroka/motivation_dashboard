class AddPhoneNumberToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phone_number, :string
    add_column :users, :twitter_username, :string
  end

  def self.down
    remove_column :users, :phone_number
    remove_column :users, :twitter_username
  end
end
