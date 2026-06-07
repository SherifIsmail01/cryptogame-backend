class SessionsController < ApplicationController
  # POST /login
  def create
    user = User.find_by(name: params[:name])

    if user && user.authenticate(params[:password])
      # ✅ FIXED: Bypasses JBuilder templates entirely to return raw JSON properties context maps
      render json: { 
        authenticated: true, 
        user: { id: user.id, name: user.name, cash_balance: user.cash_balance } 
      }, status: :ok
    else
      render json: { authenticated: false, error: "Invalid username or password" }, status: :unauthorized
    end
  end

end
