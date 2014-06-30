class RenameUserTitletoName < ActiveRecord::Migration
  def change
	  rename_column :users, :title, :name
  end
end
