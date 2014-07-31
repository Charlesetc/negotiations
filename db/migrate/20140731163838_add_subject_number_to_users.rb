class AddSubjectNumberToUsers < ActiveRecord::Migration
  def change
		add_column :users, :subject_number, :integer
  end
end
