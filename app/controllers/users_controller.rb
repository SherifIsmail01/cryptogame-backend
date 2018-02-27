class UsersController < ApplicationController

	def index
		puts "!!!! index"
		@users = User.all
	end

	def create
	    @user = User.new(user_params)
	    puts params
	    @user.cash_balance = 50000
	    puts @user.cash_balance
	    if @user.save
	    	user_id = @user.id
	    	puts user_id
	    	@first_account = Account.new({user_id: user_id, currency_name: 'Bitcoin', units_of_currency: 0})
	    	@second_account = Account.new({user_id: user_id, currency_name: 'Litecoin', units_of_currency: 0})
	    	@third_account = Account.new({user_id: user_id, currency_name: 'Etherium', units_of_currency: 0})
	    	puts @first_account
	    	puts @second_account
	    	puts @third_account
	    	if @first_account.save and @second_account.save and @third_account.save
		      	render :show, status: :created, location: @user
		    else
		    	render json: @first_account.errors, status: :unprocessable_entity
		    end
	    else
	      	render json: @user.errors, status: :unprocessable_entity
	    end
	end

	def show
		@user = User.find_by_id(params[:id])		
	end

	  def update
	  	user_id = @user.id
	    if @user_id.update(user_id_params)
	      render :show, status: :ok, location: @user_id
	    else
	      render json: @user_id.errors, status: :unprocessable_entity
	    end
	  end

	  def destroy
	  	@user.destroy
	  end

	private
	def user_params
		params.permit(:name, :email, :password)
	end
end
