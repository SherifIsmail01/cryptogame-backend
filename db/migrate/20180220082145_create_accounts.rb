class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :currency_name
      t.integer :units_of_currency

      t.timestamps
    end
  end
end
