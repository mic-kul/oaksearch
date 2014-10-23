class TopController < ApplicationController
  def products
  		@productstat = Productstat.get_popular

		topproducts = @productstat.map{|m| { :pid => m["_id"], :visits => m["value"]["visit"]}}.sort_by { |k, v| k[:visits] }.last(50)
		prod_ids = []
		@prodid2visits = []
		@visits={}
		topproducts.each do |prod|
			prod_ids.push(prod[:pid])
			@prodid2visits.push([prod[:pid], prod[:visits]])
			@visits[prod[:pid]] = prod[:visits]
		end
		@topproducts = Product.find(prod_ids)


  end

  def stores
  		@storestat = Storestat.get_popular
		topstores = @storestat.map{|m| { :pid => m["_id"], :visits => m["value"]["visit"]}}.sort_by { |k, v| k[:visits] }.last(50)
		store_ids = []
		@visits={}
		@store_id2visits = []
		topstores.each do |prod|
			store_ids.push(prod[:pid])
			@store_id2visits.push([prod[:pid], prod[:visits]])
			@visits[prod[:pid]] = prod[:visits]
		end

		@topstores = Store.find(store_ids)
  end
end
