class AddForeignLanguagesToUsersProperly < ActiveRecord::Migration
  def change
	  add_column :users, :foreign_languages, :text
  end
end
