Oakadmin::Application.routes.draw do
  get "top/products"
  get "top/stores"
  get "tickets/index"
  get "tickets/show"
  get "tickets/reply"
  post "sessions/try_login"
  get "sessions/login"
  get "sessions/logout"
  
  root 'dashboard#index'

  get '/product_add_photo/:id', to: 'products#add_photo'
  post '/product_add_photo', to: 'products#add_photo'
  get '/product_delete_photo/:id', to: 'products#delete_photo'

  get '/list_user_tickets', to: 'tickets#list_user_tickets'
  get '/show_user_ticket/:id', to: 'tickets#show_user_ticket'
  post '/show_user_ticket/:id', to: 'tickets#reply_user_ticket'

  get '/list_store_tickets', to: 'tickets#list_store_tickets'
  get '/show_store_ticket/:id', to: 'tickets#show_store_ticket'
  post '/show_store_ticket/:id', to: 'tickets#reply_store_ticket'

  resources :products do
    member do
      get 'features'
    end
  end
  
  resources :admins
  resources :features
  resources :reviews
  resources :users
  resources :stores
  resources :storeusers
  resources :storeproducts
  get '/zipcode/edit/:zid', to: 'zipcodes#edit'
  post '/zipcode/edit/:zid', to: 'zipcodes#update'
  resources :zipcodes
  
end
