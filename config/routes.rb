Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get '/users' => 'users#index', as: 'users'
    post '/users' => 'users#create', as: 'create_user'
    # get '/users/new' => 'users#new', as: 'new_user'
    get '/users/:id' => 'users#show', as: 'show_user'
    get '/user/:id/account' => 'user#accounts'
    get '/account/:id' => 'account#show', as: 'show_account'
    # get '/account/:id/edit' => 'account#edit', as: 'edit_account'
    patch '/account/:id' => 'account#update', as: 'update_account'
    delete '/account/:id' => 'account#destroy', as: 'delete_account'
end
