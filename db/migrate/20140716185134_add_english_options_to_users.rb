class AddEnglishOptionsToUsers < ActiveRecord::Migration
  def change
		add_column :users, :english_listening, :integer
		add_column :users, :english_speaking, :integer
		add_column :users, :english_reading, :integer
		add_column :users, :english_writing, :integer
  end
end
