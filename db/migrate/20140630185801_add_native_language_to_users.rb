class AddNativeLanguageToUsers < ActiveRecord::Migration
  def change
	  add_column :users, :native_language, :string
  end
end
