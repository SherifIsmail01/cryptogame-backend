Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get '/users' => 'users#index', as: 'users'
    post '/users' => 'users#create', as: 'create_user'
    # get '/users/new' => 'users#new', as: 'new_user'
    get '/users/:id' => 'users#show', as: 'user'
    get '/users/:id/accounts' => 'accounts#index', as: 'account'
    get '/accounts' => 'accounts#index', as: 'accounts'
    get '/account/:id' => 'accounts#show', as: 'show_account'
    # get '/account/:id/edit' => 'account#edit', as: 'edit_account'
    put '/users/:id/accounts/buy' => 'accounts#buy', as: 'update_account_buy'
    put '/users/:id/accounts/sell' => 'accounts#sell', as: 'update_account_sell'
    put '/users/:id/accounts/convert' => 'accounts#convert', as: 'update_account_convert'
    delete '/account/:id' => 'accounts#destroy', as: 'delete_account'
end
