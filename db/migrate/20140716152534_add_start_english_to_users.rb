class AddStartEnglishToUsers < ActiveRecord::Migration
  def change
		add_column :users, :start_english, :integer
  end
end
