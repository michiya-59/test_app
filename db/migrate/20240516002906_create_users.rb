class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.datetime :confirmed_at
      t.string :confirmation_token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
