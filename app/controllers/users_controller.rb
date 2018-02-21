class UsersController < ApplicationController
	before_action :set_user, only: [:show, :update, :destroy]
	def index
		@users = User.all
	end

	def new
		@users = User.new
	end

	def create
		User.create(user_params)
		redirect_to('/users')
	end

	def show
		@user = User.find_by_id(params[:id])		
	end


	private
	def set_user
		@user = User.find(params[:id])
	end
	def user_params
		params.require(:user).permit(:name, :cash_balance)
	end
end
