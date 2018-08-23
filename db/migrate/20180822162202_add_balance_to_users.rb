class AddBalanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :balance, :float, null: false, default: 0
  end
end
