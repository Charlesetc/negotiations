class AddIndexToNegotiationSecureKey < ActiveRecord::Migration
  def change
		add_index :negotiations, :secure_key, unique: true
  end
end
