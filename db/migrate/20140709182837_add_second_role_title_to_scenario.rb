class AddSecondRoleTitleToScenario < ActiveRecord::Migration
  def change
		add_column :scenarios, :second_role_title, :string
  end
end
