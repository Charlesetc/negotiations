class RemoveLanguageFromNegotiations < ActiveRecord::Migration
  def change
  	remove_column :negotiations, :language
  end
end
