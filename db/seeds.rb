# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Account.destroy_all

User.create([
	{
		name: "John",
		cash_balance: 50000
	},
	{
		name: "Erick",
		cash_balance: 50000
	},
	{
		name: "David",
		cash_balance: 50000
	}
	])



Account.create([
	{
		currency_name: "Bitcoin",
		units_of_currency: 0
	},
	{
		currency_name: "Litecoin",
		units_of_currency: 0
	},
	{
		currency_name: "Etherium",
		units_of_currency: 0
	}
	])	
