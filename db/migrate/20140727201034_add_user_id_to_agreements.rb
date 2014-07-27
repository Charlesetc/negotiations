class AddUserIdToAgreements < ActiveRecord::Migration
  def change
		add_column :agreements, :user_id, :integer
  end
end
