class AddResearchToUsers < ActiveRecord::Migration
  def change
		add_column :users, :research, :text
  end
end
