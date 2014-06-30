class AddNativeLanguagesToUsers < ActiveRecord::Migration
  def change
	  add_column :users, :native_languages, :text
  end
end
