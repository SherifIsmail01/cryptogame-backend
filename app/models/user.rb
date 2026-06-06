class User < ApplicationRecord
	has_secure_password

	validates :name, presence: true, uniqueness: true

	has_many :accounts, dependent: :destroy

	has_many :transactions, through: :accounts
end
