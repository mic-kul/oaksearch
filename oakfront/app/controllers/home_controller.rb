require 'treetop'

class HomeController < ApplicationController
	respond_to :json
	
	def index
		#@productstat = Productstat.collection.group(:key => "product", :initial => { :sum => 0 }, :reduce => "function(doc,prev) { prev.sum += doc.visit; }")
		@productstat = Productstat.get_popular

		topproducts = @productstat.map{|m| { :pid => m["_id"], :visits => m["value"]["visit"]}}.sort_by { |k, v| k[:visits] }.last(5)
		prod_ids = []
		@prodid2visits = []
		topproducts.each do |prod|
			prod_ids.push(prod[:pid])
			@prodid2visits.push([prod[:pid], prod[:visits]])
		end

		@topproducts = Product.find(prod_ids)

		@storestat = Storestat.get_popular
		topstores = @storestat.map{|m| { :pid => m["_id"], :visits => m["value"]["visit"]}}.sort_by { |k, v| k[:visits] }.last(5)
		store_ids = []
		@store_id2visits = []
		topstores.each do |prod|
			store_ids.push(prod[:pid])
			@store_id2visits.push([prod[:pid], prod[:visits]])
		end

		@topstores = Store.find(store_ids)

	end

	def stats
		add_breadcrumb "stats", :home_stats_path
		@recentProducts = Product.all(:order => 'created_date DESC', :limit => 10)
		@recentProductsUpdated = Product.where('modified_date > created_date')
			.order('modified_date DESC').limit(10)
		@recentPriceDrops = PriceList.all()
		@reviews = Review.order("created_date DESC").limit(10)
		@users = User.find_by_sql("SELECT u.nick, COUNT(r.review_id) revs FROM users u INNER JOIN REVIEWS r ON u.user_id = r.user_id WHERE rownum < 10 GROUP BY u.nick")
		@priceRises = Pricelist.find_by_sql("SELECT (pl.price_new-pl.price_old) pdrop, pl.price_new, pl.price_old, p.name pname, s.name sname FROM PRICE_LIST pl 
			INNER JOIN STORE_PRODUCTS sp ON pl.store_product_id = sp.store_product_id 
			INNER JOIN STORES s ON s.store_id = sp.store_id 
			INNER JOIN PRODUCTS p ON sp.product_id = p.product_id 
			WHERE pl.price_old > 0 AND (pl.price_new-pl.price_old) > 0 AND ROWNUM < 10 ORDER BY pdrop DESC")

		@priceDrops = Pricelist.find_by_sql("SELECT (pl.price_new-pl.price_old) pdrop, pl.price_new, pl.price_old, p.name pname, s.name sname FROM PRICE_LIST pl INNER JOIN STORE_PRODUCTS sp 
			ON pl.store_product_id = sp.store_product_id INNER JOIN STORES s ON s.store_id = sp.store_id 
			INNER JOIN PRODUCTS p ON sp.product_id = p.product_id WHERE pl.price_old > 0 AND (pl.price_new-pl.price_old) < 0 AND ROWNUM < 10 ORDER BY pdrop DESC")

	end


	def search
		load "#{Rails.root}/lib/oak/oak_to_cypher.rb"
		load "#{Rails.root}/lib/oak/parser.rb"
  		ret = Oak::Parser.parse("(#{params[:term]})")
  		respond_with ret
  	end

  	def contact
  		add_breadcrumb "contact", :contact_path
  	end

  	def contact_save
  		flash[:notice] = "Thank you for sending message! Our staff will contact you soon."
  		redirect_to root_path
  	end

  	def cookie_policy
  		add_breadcrumb "cookie policy", :cookie_policy_path
  	end

  	def privacy_policy
  		add_breadcrumb "cookie policy", :privacy_policy_path
  	end

  	def about
  		add_breadcrumb "about", :about_path
  	end
end
