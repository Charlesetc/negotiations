class AddAcquiredEnglishToUsers < ActiveRecord::Migration
  def change
		add_column :users, :acquired_english, :text
  end
end
