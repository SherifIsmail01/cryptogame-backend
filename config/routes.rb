Rails.application.routes.draw do
    
    post 'login', to: 'sessions#create', defaults: { format: :json }
    
    get '/users' => 'users#index', as: 'users'
    post '/users' => 'users#create', as: 'create_user'

    namespace :api, defaults: { format: :json } do
        get '/crypto_rates/historical_month' => 'crypto_rates#historical_month', as: 'crypto_rates_historical'

        get 'crypto_rates/global_volume', to: 'crypto_rates#global_volume'

        post 'login', to: 'sessions#create'
        
        # Add this matching get route alongside your existing graph routes:
        get 'crypto_rates/spot/:coin_id', to: 'crypto_rates#spot_prices'
    end

    get '/users/:id' => 'users#show', as: 'user'
    put '/users/:id' => 'users#update', as: 'update_user'
    delete '/users/:id' => 'users#destroy', as: 'delete_account'

    get '/users/:id/accounts' => 'accounts#index', as: 'account'
    get '/accounts' => 'accounts#index', as: 'accounts'
    get '/account/:id' => 'accounts#show', as: 'show_account'

    put '/users/:id/buy' => 'accounts#buy', as: 'update_account_buy'
    put '/users/:id/sell' => 'accounts#sell', as: 'update_account_sell'
    put '/users/:id/convert' => 'accounts#convert', as: 'update_account_convert'

    get '/transactions' => 'transactions#index', as: 'transaction'
    post '/transactions' => 'transactions#create', as: 'new_transactions'
end
