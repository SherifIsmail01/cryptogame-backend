class AddNumberOfUnitsToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :number_of_units, :integer
  end
end
