class AddLanguageToScenarios < ActiveRecord::Migration
  def change
		add_column :scenarios, :language, :string
  end
end
