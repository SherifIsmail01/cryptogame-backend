class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def create
	    @user = User.new(user_params)
	    @user.cash_balance = 50000

	    if @user.save
	    	# Create 3 new accounts here
	    	user_id = @user.id
	    	@first_account = Account.new({user_id: user_id, name: 'Bitcoin', amount: ''})
	    	@second_account = Account.new({user_id: user_id, name: 'Bitcoin', amount: ''})
	    	@third_account = Account.new({user_id: user_id, name: 'Bitcoin', amount: ''})

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
		params.require(:user).permit(:name)
	end
end
