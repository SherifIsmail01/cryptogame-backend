class UsersController < ApplicationController

	def index
		puts "!!!! index"
		@users = User.all
	end

	def create
		puts 'params'
		puts params
		puts 'user_params'
		puts user_params 
		
	    @user = User.new(user_params)
	    @user.cash_balance = 50000
	    puts "!!!!! create"
	    p @user
	    if @user.save
	    	user_id = @user.id
	    	@first_account = Account.new({user_id: user_id, currency_name: 'Bitcoin', units_of_currency: 0})
	    	@second_account = Account.new({user_id: user_id, currency_name: 'Litecoin', units_of_currency: 0})
	    	@third_account = Account.new({user_id: user_id, currency_name: 'Etherium', units_of_currency: 0})

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
		params.permit(:name)
	end
end
