class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :token

      t.timestamps

      t.index :email, unique: true
      t.index :token, unique: true
    end
  end
end
