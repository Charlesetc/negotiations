class AddGoalsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :goals, :string
  end
end
