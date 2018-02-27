class SessionsController < ApplicationController
	def new
		@user = User.new
	end

	def create
	    user_params = params.permit(:email, :password)
	    @user = User.confirm(user_params)
	    if @user
	      	login(@user)
	      	flash[:notice] = "Successfully logged in"
	    else
	    	flash[:notice] = "Incorrect email or password"
	    end
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = "Successfully logged out"
    end

end
