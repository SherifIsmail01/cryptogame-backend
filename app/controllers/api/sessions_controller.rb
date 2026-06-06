class Api::SessionsController < ApplicationController
  # POST /api/login
  def create
    user = User.find_by(name: params[:name])

    # Validate that the user exists and the typed password matches the encrypted hash
    if user && user.authenticate(params[:password])
      # Securely return the user data back to React
      render json: { authenticated: true, user: user }, status: :ok
    else
      render json: { authenticated: false, error: "Invalid name or password" }, status: :unauthorized
    end
  end
end
