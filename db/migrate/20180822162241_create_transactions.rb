class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :user_from_id, null: false
      t.integer :user_to_id, null: false
      t.float :amount, null: false

      t.timestamps
    end

    add_index :transactions, :user_from_id
    add_index :transactions, :user_to_id
  end
end
