class AddEndBackgroundToUsers < ActiveRecord::Migration
  def change
			add_column :users, :end_background, :timestamp
  end
end
