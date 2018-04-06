class User < ApplicationRecord
	has_many :accounts, dependent: :destroy
	has_many :transactions, through: :accounts, dependent: :destroy
end
