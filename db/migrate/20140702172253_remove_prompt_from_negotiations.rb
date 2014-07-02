class RemovePromptFromNegotiations < ActiveRecord::Migration
  def change
		remove_column :negotiations, :prompt
  end
end
