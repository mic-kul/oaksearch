Oakfront::Application.routes.draw do
	get "reviews/index"
	get "sessions/login"
	post "sessions/login"
	get "sessions/logout"
	get "sessions/home"
	get "sessions/profile"
	get "sessions/setting"
  	post "sessions/try_login"

	get "user/new"
	post "user/create"
	get "user/show"
	get "user/watched_products", to: 'user#watched_products'
	get "user/price_offers", to: "user#price_offers"
	get "user/price_offer/:id", to: "user#price_offer"
	get 'user/edit_profile', to: 'user#edit_profile'
	post 'user/edit_profile', to: 'user#edit_profile'
	get 'user/change_password'
	get 'user/search_history', to: 'user#search_history'
	post 'user/change_password'
	get 'user_messages', to: 'user#list_messages'
	post 'save_message', to: 'user#save_message'

	get 'user_tickets', to: 'user#list_tickets'
	get 'new_store_ticket', to: 'user#new_store_ticket'
	
	get 'new_admin_ticket', to: 'user#new_admin_ticket'
	get 'show_store_ticket/:id', to: 'user#show_store_ticket'
	post 'show_store_ticket/:id', to: 'user#reply_store_ticket'

	get 'show_admin_ticket/:id', to: 'user#show_admin_ticket'
	post 'show_admin_ticket/:id', to: 'user#reply_admin_ticket'

	post 'new_store_ticket', to: 'user#new_store_ticket_save'
	post 'new_admin_ticket', to: 'user#new_admin_ticket_save'

	get 'stores/index'

	root :to => "home#index"
	get "/home_stats", to: 'home#stats'
	get 'search', to: 'home#search'
	get '/cookie_policy', to: 'home#cookie_policy'
	get '/privacy_policy', to: 'home#privacy_policy'
	get '/about', to: 'home#about'
	get '/contact', to: 'home#contact'
	post '/contact', to: 'home#contact_save'
	
	resources :product do
		member do
		  get 'features'
		end
	end
	resources :user
	resources :reviews
	
	get 'stores', to: 'stores#index'
	get 'stores/:id', to: 'stores#show'
	get 'add_to_blacklist/:id', to: 'stores#add_to_blacklist'
	get 'remove_from_blacklist/:id', to: 'stores#remove_from_blacklist'

	get '/products_price_offer/:id', to: 'product#price_offer'
	post '/products_price_offer/:id', to: 'product#price_offer_save'
	get '/products/:id', to: 'product#show'
	get '/products_recently_added', to: 'product#recently_added'
	get '/products_recently_updated', to: 'product#recently_updated'
	get '/products_graph/:id/(:limit)', to: 'product#show_graph'
	get '/show_graph_json/:id/(:limit)', to: 'product#show_graph_json'
	get '/products_show_similiar/:id(/:limit)', to: 'product#show_similiar'

	get '/products_compare/:one/:two', to: 'product#compare'
	get '/products_compare/:one/:two/:three', to: 'product#compare'
	get '/products_compare/:one/:two/:three/:four', to: 'product#compare'
	get '/products_compare/:one/:two/:three/:four/:five', to: 'product#compare'

	get '/products_search', to: 'product#search'


	get '/watch_product/:product_id', to: 'product#watch_product' 
	get '/unwatch_product/:product_id', to: 'product#unwatch_product' 
	post 'product/add_review'
end
