class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :mobile, index: true
      t.string :code
      t.datetime :code_expires_at

      t.timestamps
    end
  end
end
