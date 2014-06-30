class RemoveNativeLanguageFromUsers < ActiveRecord::Migration
  def change
	 remove_column :users, :native_language 
  end
end
