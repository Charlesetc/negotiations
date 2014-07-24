class AddEmotionsToUsers < ActiveRecord::Migration
  def change
		add_column :users, :emotions, :text
  end
end
