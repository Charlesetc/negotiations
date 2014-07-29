class AddAgreementTimeToNegotiations < ActiveRecord::Migration
  def change
		add_column :negotiations, :agreement_time, :timestamp
  end
end
