class AccountsController < ApplicationController
	before_action :set_account, only: [:show, :update, :destroy]

	def index
		@user = User.find(params[:user_id])
		@accounts = Account.all
	end

	def show
		account_id = params[:id]
		@account = Account.find_by(id: account_id)
		user_id = @account.user_id
		@user = User.find_by(id: user_id)
	end

	def new
		@account = Account.new(account_params)
	end

	def create
		@account = Account.new(account_params)
		@account.user_id = current_user.id
	end

	def edit
		account_id = params[:id]
		@account = Account.find_by(id: account_id)
	end

	def update
		account_id = params[:id]
		@account = Account.find_by(id: account_id)
		@account.update(account_params)
		redirect_to show_account(@account)
	end

	def destroy
	end


	private

	def set_account
		@account = Account.find(params[:id])
	end
	def account_params
		params.require(:account).permit(:currency_name, :units_of_currency)
	end
end
