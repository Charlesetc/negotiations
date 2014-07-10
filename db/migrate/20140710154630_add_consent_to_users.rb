class AddConsentToUsers < ActiveRecord::Migration
  def change
	  add_column :users, :consent, :boolean, default: false
  end
end
