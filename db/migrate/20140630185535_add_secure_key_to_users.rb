class AddSecureKeyToUsers < ActiveRecord::Migration
  def change
	  add_column :users, :secure_key, :string
  end
end
