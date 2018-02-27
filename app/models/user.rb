class User < ApplicationRecord
	validates :email, presence: true, uniqueness: true
	validates :password, length: {minimum: 6}

	has_secure_password

	has_many :accounts, dependent: :destroy

	def self.confirm(params)
	    @user = User.find_by({email: params[:email]})
	    @user ? @user.authenticate(params[:password]) : false
  	end


end
