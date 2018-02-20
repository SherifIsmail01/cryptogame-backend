class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.number :user_id
      t.string :currency-name
      t.number :units-of-currency

      t.timestamps
    end
  end
end
