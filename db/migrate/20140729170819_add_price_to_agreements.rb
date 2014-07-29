class AddPriceToAgreements < ActiveRecord::Migration
  def change
		add_column :agreements, :price, :string
  end
end
