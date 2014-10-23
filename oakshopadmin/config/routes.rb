Rails.application.routes.draw do
  get 'offers/index'
  post 'offers/make_offer_save', to: 'offers#make_offer_save'
  get 'offers/show/:id', to: 'offers#show'

  get 'offers/make_offer'

  get '/list_user_tickets', to: 'home#list_user_tickets'
  get '/show_user_ticket/:id', to: 'home#show_user_ticket'
  post '/show_user_ticket/:id', to: 'home#reply_user_ticket'

  get '/list_admin_tickets', to: 'home#list_admin_tickets'
  get '/show_admin_ticket/:id', to: 'home#show_admin_ticket'
  get 'new_admin_ticket', to: 'home#new_admin_ticket'
  post 'new_admin_ticket', to: 'home#new_admin_ticket_save'
  post '/show_admin_ticket/:id', to: 'home#reply_admin_ticket'



	root 'home#index'

	post "sessions/try_login"
	get "sessions/login"
	get "sessions/logout"

	resources :storeusers
	resources :storeproducts
end
