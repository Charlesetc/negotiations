class AddEnglishHomeToUsers < ActiveRecord::Migration
  def change
		add_column :users, :english_home, :boolean
  end
end
