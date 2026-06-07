class AddMissingColumnsToTransactions < ActiveRecord::Migration[7.0]
  def change
    # Add 'coin_name' if it was skipped in the initial setup
    unless column_exists?(:transactions, :coin_name)
      add_column :transactions, :coin_name, :string
    end

    # Double check and add any other missing floating metrics to be 100% safe
    unless column_exists?(:transactions, :units)
      add_column :transactions, :units, :float
    end

    unless column_exists?(:transactions, :price_per_unit)
      add_column :transactions, :price_per_unit, :float
    end

    unless column_exists?(:transactions, :total_amount)
      add_column :transactions, :total_amount, :float
    end
  end
end
