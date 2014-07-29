class AddDescriptionToAgreements < ActiveRecord::Migration
  def change
		add_column :agreements, :description, :text
	end
end
