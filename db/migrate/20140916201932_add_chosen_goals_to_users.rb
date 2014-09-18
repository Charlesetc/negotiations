class AddChosenGoalsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :chosen_goals, :string
  end
end
