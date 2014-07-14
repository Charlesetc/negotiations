class AddBackgroundToUsers < ActiveRecord::Migration
  def change
		add_column :users, :background, :boolean, default: false
  end
end
