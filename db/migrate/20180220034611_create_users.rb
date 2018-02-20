class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.number :id
      t.string :name
      t.number :cash-balance

      t.timestamps
    end
  end
end
