class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.text :general
      t.text :first_role
      t.text :second_role
      t.string :title

      t.timestamps
    end
  end
end
