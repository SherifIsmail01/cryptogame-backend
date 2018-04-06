class TransactionsController < ApplicationController

	def index
		@transaction = Transaction.all
	end

	def show
		# @user = User.find_by_id(params[:id])
		# user_id = @user.id
		# account = Account.find_by_id_and_acc
	end

end
