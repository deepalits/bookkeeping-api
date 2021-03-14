class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :description
      t.float :amount
      t.integer :transaction_type
      t.references :contact, foreign_key: { to_table: :contacts }

      t.timestamps
    end
  end
end
