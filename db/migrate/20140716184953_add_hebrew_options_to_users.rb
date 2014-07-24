class AddHebrewOptionsToUsers < ActiveRecord::Migration
  def change
		add_column :users, :hebrew_listening, :integer
		add_column :users, :hebrew_speaking, :integer
		add_column :users, :hebrew_reading, :integer
		add_column :users, :hebrew_writing, :integer
  end
end
