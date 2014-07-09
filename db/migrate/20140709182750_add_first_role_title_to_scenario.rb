class AddFirstRoleTitleToScenario < ActiveRecord::Migration
  def change
		add_column :scenarios, :first_role_title, :string
  end
end
