class AddStartTimeToNegotiations < ActiveRecord::Migration
  def change
		add_column :negotiations, :start_time, :timestamp
  end
end
