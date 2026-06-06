class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def create
		@user = User.new(user_params)
		@user.cash_balance = 500000

		# Wrap in a database transaction block
		ActiveRecord::Base.transaction do
		if @user.save
			@first_account  = Account.new(user: @user, currency_name: 'Bitcoin', units_of_currency: 0)
			@second_account = Account.new(user: @user, currency_name: 'Litecoin', units_of_currency: 0)
			@third_account  = Account.new(user: @user, currency_name: 'Ethereum', units_of_currency: 0)

			if @first_account.save! && @second_account.save! && @third_account.save!
			# ✅ FIXED: Removed the 'return' keyword completely. 
			# Rails will now commit the transaction cleanly!
			render json: { id: @user.id, name: @user.name, cash_balance: @user.cash_balance }, status: :created
			end
		else
			render json: @user.errors, status: :unprocessable_entity
		end
		end

	rescue ActiveRecord::RecordInvalid => e
		render json: { error: "Account initialization failed: #{e.message}" }, status: :unprocessable_entity
    end




	def show
		@user = User.find_by_id(params[:id])		
	end

	def update
		user_id = params[:id]
		@user = User.find_by(id: user_id)
		if @user.update(user_params)
		  	render :show, status: :ok, location: @user
		else
		  	render json: @user_id.errors, status: :unprocessable_entity
		end
	end

	def destroy
	end

	private
	def user_params
		if params[:user].present? && params[:user][:password].present?
			params.require(:user).permit(:name, :password)
		else
			params.permit(:name, :password)
		end
	end
end
