class RemoveEmailFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :email, :text
  end
end
