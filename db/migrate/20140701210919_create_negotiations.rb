class CreateNegotiations < ActiveRecord::Migration
  def change
    create_table :negotiations do |t|
      t.string :secure_key
      t.string :language
      t.string :prompt

      t.timestamps
    end
  end
end
