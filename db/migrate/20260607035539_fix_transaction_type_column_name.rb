class FixTransactionTypeColumnName < ActiveRecord::Migration[7.1]
  def change
    # If the column was accidentally saved as 'type', rename it to 'transaction_type'
    if column_exists?(:transactions, :type)
      rename_column :transactions, :type, :transaction_type
    # If the column doesn't exist at all, add it freshly
    elsif !column_exists?(:transactions, :transaction_type)
      add_column :transactions, :transaction_type, :string
    end
  end
end
