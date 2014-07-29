class AddBooleanToAgreements < ActiveRecord::Migration
  def change
		add_column :agreements, :agreement_boolean, :boolean
  end
end
