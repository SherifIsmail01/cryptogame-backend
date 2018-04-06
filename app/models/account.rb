class Account < ApplicationRecord
	belongs_to :user
	has_many :transactions, through: :user, dependent: :destroy
end
