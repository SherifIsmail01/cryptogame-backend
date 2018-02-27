class AccountsController < ApplicationController

	def index
		# if current_user.id != @accounts.user_id
			@accounts = Account.all

	end

	def create
		@account = Account.new(account_params)
		@account.user_id = current_user.id
	end

	def show
		account_id = params[:id]
		@account = Account.find_by(id: account_id)
		user_id = @account.user_id
		@user = User.find_by(id: user_id)
	end

	def update
		account_id = params[:id]
		@account = Account.find_by(id: account_id)
		if current_user.id != @account.user_id
			flash[:notice] = "request denied"
		else
			@account.update(account_params)
		end
	end

	def buy
			user_id = params[:id]
			user = User.find_by_id(user_id)
			@accounts = user.accounts
			num_of_units = params[:num_of_units]
			currency_to_buy = params[:currency_to_buy]
			current_val_of_Etherium = params[:current_val_of_Etherium]
			current_val_of_Litecoin = params[:current_val_of_Litecoin]
			current_val_of_Bitcoin = params[:current_val_of_Bitcoin]

			total_price_of_purchase = (num_of_units.to_i * params[currency_to_buy])
			puts params[currency_to_buy]
			puts total_price_of_purchase

			if 	user.cash_balance >= total_price_of_purchase
				myAccountToUpdate = Account.find_by_user_id_and_currency_name(params[:id], currency_to_buy)
				if 	myAccountToUpdate.update_attribute(:units_of_currency, myAccountToUpdate.units_of_currency + num_of_units.to_i)
					user.update_attribute(:cash_balance, user.cash_balance - total_price_of_purchase.to_i)
			    	render :index
			    else
			    	puts 'error'
			    end
			else
				flash[:notice] = "Insufficient funds"
				render :index
			end
	end

	def convert
			user_id = params[:id]
			user = User.find_by_id(user_id)
			@accounts = user.accounts
			convert_from_currency = params[:convert_from_currency]
			num_of_units_of_converted_from_currency = params[:num_of_units_of_converted_from_currency]
			convert_to_currency = params[:convert_to_currency]
			current_val_of_Etherium = params[:current_val_of_Etherium]
			current_val_of_Litecoin = params[:current_val_of_Litecoin]
			current_val_of_Bitcoin = params[:current_val_of_Bitcoin]

			price_of_converted_from_currency = (num_of_units_of_converted_from_currency.to_i * params[convert_from_currency])
	
			if price_of_converted_from_currency >= params[convert_to_currency]
				if price_of_converted_from_currency / params[convert_to_currency] % 2 === 0
					num_of_units_of_converted_to_currency = price_of_converted_from_currency.to_i / params[convert_to_currency]
					myAccountToConvertFrom = Account.find_by_user_id_and_currency_name(params[:id], convert_from_currency)
					myAccountToConvertTo = Account.find_by_user_id_and_currency_name(params[:id], convert_to_currency)
					if 	myAccountToConvertFrom.update_attribute(:units_of_currency, myAccountToConvertFrom.units_of_currency - num_of_units_of_converted_from_currency.to_i)
						myAccountToConvertTo.update_attribute(:units_of_currency, myAccountToConvertTo.units_of_currency + num_of_units_of_converted_to_currency.to_i)
						puts "converted"
						render :index
					else
						puts "error"
					end
				else
					division = price_of_converted_from_currency.to_i / params[convert_to_currency]
					num_of_units_of_converted_to_currency = division.floor
					remainder = (division - num_of_units_of_converted_to_currency) * params[convert_to_currency]
					myAccountToConvertFrom = Account.find_by_user_id_and_currency_name(params[:id], convert_from_currency)
					myAccountToConvertTo = Account.find_by_user_id_and_currency_name(params[:id], convert_to_currency)
					if 	myAccountToConvertFrom.update_attribute(:units_of_currency, myAccountToConvertFrom.units_of_currency - num_of_units_of_converted_from_currency.to_i)
						myAccountToConvertTo.update_attribute(:units_of_currency, myAccountToConvertTo.units_of_currency + num_of_units_of_converted_to_currency.to_i)
						user.update_attribute(:cash_balance, user.cash_balance + remainder)
						puts "converted"
						render :index
					else
						puts "error"
					end
				end
			else
				flash[:notice] = "Insufficient amount, please increase number of units or change currency"
				render :index	
			end
	end

	def sell
			user_id = params[:id]
			user = User.find_by_id(user_id)
			@accounts = user.accounts
			sold_for = params[:sold_for]
			num_of_units = params[:num_of_units]
			currency_to_sell = params[:currency_to_sell]
			current_val_of_Etherium = params[:current_val_of_Etherium]
			current_val_of_Litecoin = params[:current_val_of_Litecoin]
			current_val_of_Bitcoin = params[:current_val_of_Bitcoin]

			total_price_of_sale = (num_of_units.to_i * params[currency_to_sell])
			myAccountToUpdate = Account.find_by_user_id_and_currency_name(params[:id], currency_to_sell)

			if 	myAccountToUpdate.units_of_currency.to_i >= num_of_units.to_i
				if 	myAccountToUpdate.update_attribute(:units_of_currency, myAccountToUpdate.units_of_currency - num_of_units.to_i)
					user.update_attribute(:cash_balance, user.cash_balance + total_price_of_sale)
			    	render :index
			    else
			    	puts 'error'
			    end
			else
				flash[:notice] = "Incorrect number of units"
			end
	end

	def destroy
		@account.destroy
	end


	private

	def account_params
		params.permit(:currency_name, :units_of_currency)
	end
end
