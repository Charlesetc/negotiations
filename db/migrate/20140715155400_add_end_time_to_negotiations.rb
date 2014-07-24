class AddEndTimeToNegotiations < ActiveRecord::Migration
  def change
		add_column :negotiations, :end_time, :timestamp
  end
end
