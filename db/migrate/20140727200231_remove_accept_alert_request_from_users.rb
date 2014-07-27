class RemoveAcceptAlertRequestFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :accept_alert_request
  end
	
	def down
		add_column :users, :accept_alert_request, :boolean, default: false
	end
end
