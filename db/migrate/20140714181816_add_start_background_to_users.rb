class AddStartBackgroundToUsers < ActiveRecord::Migration
  def change
		add_column :users, :start_background, :timestamp
  end
end
