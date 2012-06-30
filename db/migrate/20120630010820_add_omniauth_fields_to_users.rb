class AddOmniauthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, limit: 30
    add_column :users, :uid, :integer
  end
end
