class AddFirstUserIdToNegotiations < ActiveRecord::Migration
  def change
		add_column :negotiations, :first_user_id, :integer
  end
end
