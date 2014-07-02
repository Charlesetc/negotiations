class AddScenarioIdToNegotiations < ActiveRecord::Migration
  def change
		add_column :negotiations, :scenario_id, :integer
  end
end
