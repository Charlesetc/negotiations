class AddSecondUserIdToNegotiations < ActiveRecord::Migration
  def change
		add_column :negotiations, :second_user_id, :integer
  end
end
