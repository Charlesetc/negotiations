class AddAcceptAlertRequestToUsers < ActiveRecord::Migration
  def change
		add_column :users, :accept_alert_request, :boolean, default: false
  end
end
