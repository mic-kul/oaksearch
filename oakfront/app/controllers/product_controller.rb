class ProductController < ApplicationController
  add_breadcrumb "products", :product_index_path
  respond_to :json, only: :show_graph
  before_filter :authenticate_user, :only => [:watch_product, :unwatch_product, :priceoffer, :priceoffersave, :add_review]

	def index
    	@products = Product.all(:order => "name ASC")
	end

	def price_offer
		@product = Product.find(params[:id])

	end

	def price_offer_save
		@product = Product.find(params[:product_id])
		message = params[:message]

		auction = Auction.new
		auction.user_id = @current_user.user_id
		auction.product_id = @product.product_id
		auction.message = message
		if params[:interval] == 3 || params[:interval == 7] || params[:interval] == 14
			auction.end_date = Time.now + (60*60*24*params[:interval])
		else
			auction.end_date = Time.now + (60*60*24*3)
		end
		ret = auction.save
		if ret
			flash[:notice] = "Price offer ask has been added"
		else
			flash[:error] ="Couldn't save price offer ask, please try again!"
		end
		redirect_to product_url(@product)

	end

	def search

		@query = []
		@query = params[:query].split(',') if params[:query]
		criteria = ""
		criteriaFeat =""
		counter = 0
		binds = []
		bindsFeat = []

		separator = "OR"
		separator = "AND" if params[:exactmatch]

		@query.each do |p|
			if binds.length != 0
				criteria += " "+separator+" "
				criteriaFeat += " "+separator+" "
			end
			param = "%#{p.strip.upcase}%"
			criteria += " UPPER(p.name) LIKE ?"
			binds.push(param)

			criteriaFeat += " UPPER(f.feature_name) LIKE  ? "
			bindsFeat.push(param)
		end

		a = "SELECT p.name, p.product_id, f.feature_name, f.feature_type from PRODUCTS p JOIN PRODUCT_FEATURES pf on p.product_id = pf.product_id join features f on f.feature_id = pf.feature_id WHERE"
		a += criteriaFeat
		a += " 0 = 1" if criteriaFeat.length == 0


		matchQuery = "SELECT sum(1) matches, p.name, p.product_id from PRODUCTS p JOIN PRODUCT_FEATURES pf on p.product_id = pf.product_id join features f on f.feature_id = pf.feature_id WHERE"
		matchQuery+= criteriaFeat
		matchQuery+= " 0 = 1" if criteriaFeat.length == 0
		matchQuery+=" group by p.product_id, p.name order by matches desc"
		bindsFeat.unshift(a)
		
		feats= Product.find_by_sql bindsFeat
		
		@h = {}
		feats.each do |prod|
			if @h.has_key?(prod.product_id)
				@h[prod.product_id].push([prod.feature_type, prod.feature_name])
			else
				@h[prod.product_id] = [[prod.feature_type ,prod.feature_name]]
			end
		end

		bindsFeat[0] = matchQuery
		@products = Product.find_by_sql bindsFeat
		if @products.blank?
			flash[:error] = "Your search query didn't return any results. Maybe try to describe your expectations in different words, please?"
		else
			if @current_user
				sh = Searchhistory.new
				sh.user = @current_user.user_id
				sh.query = request.original_fullpath
				sh.timestamp = DateTime.current
				sh.date= Date.today.to_s(:db)
				sh.count = @products.length
				sh.save
			end

		end

	end	

	def show

		@product = Product.find(params[:id])
		#productstat = Productstat.find_or_create_by(product: @product.product_id)
		@photos = Photo.find_by_sql(["SELECT p.photo_path FROM product_photos x INNER JOIN PHOTOS p ON x.photo_id = p.photo_id WHERE x.product_id = ? ", @product.product_id])

		productstat = Productstat.where(:product => @product.product_id, :date => Date.today.to_s(:db)).first_or_create
		productstat.inc :visit => 1
		productstat.save

		@productstats = Productstat.where(:product => @product.product_id)

	    add_breadcrumb @product.name, :product_path
	    @watched_by_current_user = nil
	    if @current_user != nil
	      @selected_watched = Userwatchedproduct.where(user_id: @current_user.user_id, product_id: @product.product_id, store_product_id: nil).first
	      if @selected_watched != nil
	        @watched_by_current_user = true
	      end
	    end
	    @averagePrice = Pricelist.find_by_sql(["SELECT AVG(sp.price) avg_price, COUNT(sp.price) price_count FROM store_products sp WHERE sp.product_id = ?", @product.product_id]).first
	    @pricesList = Pricelist.find_by_sql(["SELECT sp.price, s.* from store_products sp inner join STORES s on sp.store_id = s.store_id WHERE sp.product_id = ? ", @product.product_id])
	    # 	GROUP BY pl.datetime order_by pl.datetime DESC
		@priceHistory = Pricelist.find_by_sql(["SELECT MIN(pl.price_new) price_min, MAX(pl.price_new) price_max, AVG(pl.price_new) price_avg, TRUNC(pl.datetime) datetime FROM PRICE_LIST pl 
			INNER JOIN STORE_PRODUCTS sp ON sp.store_product_id = pl.store_product_id WHERE sp.product_id = ?  GROUP BY TRUNC(pl.datetime)", @product.product_id])
	end

	def show_graph
		dbid = params[:id].to_i
		limit = 5
		limit = params[:limit].to_i if params[:limit]
		if limit < 0 || limit > 20
			limit = 5
		end
		@id = dbid
		@product = Product.find(dbid)

	end

	def show_graph_json
		neo = Neography::Rest.new
		dbid = params[:id].to_i
		limit = 5
		limit = params[:limit].to_i if params[:limit]
		if limit < 0 || limit > 20
			limit = 5
		end
		#MATCH (a:Product { dbid: 105})-[r:HAS_FEATURE]->(b:Feature)<-[r2:HAS_FEATURE]-(m:Product) RETURN m.name,m.dbid, type(r), collect(b.name+'@@@'+b.value), count(b) ORDER BY count(b) DESC LIMIT 5
		cypher_query =  " MATCH (a:Product { dbid: #{dbid}})-[r:HAS_FEATURE]->(b:Feature)<-[r2:HAS_FEATURE]-(m:Product) "
		cypher_query << " RETURN m.name,m.dbid, type(r), collect(b.name), count(b)"
		cypher_query << " ORDER BY count(b) DESC LIMIT #{limit}"


  		puts cypher_query
		res = neo.execute_query(cypher_query)["data"]
		puts res
		#data = res.inject({}) {|h,i| t = h; i.each {|n| t[n] ||= {}; t = t[n]}; h}
  		render json: res.to_json
	end

	def show_graph_jsonx
		render json: follower_matrix.map{|fm| {"name" => fm[0], fm[1] => fm[3][1..(fm[1].size - 2)].split(", ")} }.to_json
	end

	def follower_matrix
	  neo = Neography::Rest.new
	  #cypher_query =  " START a = node(*)"
	  cypher_query = " MATCH (a:Product { dbid: 62})-[r:HAS_FEATURE]->(b:Feature)<-[r2:HAS_FEATURE]-(m:Product)"
	  cypher_query << " RETURN m.name, type(r), collect(m.name), collect(b.name+':'+b.value), count(b)"
	  cypher_query << " ORDER BY count(b) DESC"
	  puts cypher_query

	  neo.execute_query(cypher_query)["data"]
	end 

	def show_similiar
		neo = Neography::Rest.new
		dbid = params[:id].to_i
		limit = 5
		limit = params[:limit].to_i if params[:limit]
		if limit < 0 || limit > 20
			limit = 5
		end
		cypher_query =  " MATCH (me:Product { dbid: #{dbid} })-[r1:HAS_FEATURE]->(n:Feature)<-[r2:HAS_FEATURE]-(m:Product)"
		cypher_query << " RETURN m.name,m.dbid,count(n)"
		cypher_query << " ORDER BY count(n) DESC LIMIT #{limit}"
		res = neo.execute_query(cypher_query)["data"]
		data = res.inject({}) {|h,i| t = h; i.each {|n| t[n] ||= {}; t = t[n]}; h}
  		render json: parse_neo(data).to_json
	end

	def recently_added
  		@products = Product.all(:order => 'created_date DESC', :limit => 10)
	end

	def recently_updated
  		@products = Product.where('created_date <> modified_date')
		.order('modified_date DESC').limit(10)
	end

	def add_review
		@product = Product.find(params[:pid])
		@review = Review.new
		@review.product_id = params[:pid]
		@review.user_id = @current_user.user_id
		@review.review_txt = params[:review_txt]
		@review.rating = params[:rating]
		ret = @review.save
		if ret
			flash[:notice] = "Review saved, thank you!"
		else
			flash[:error] ="Couldn't save review. Make sure, you haven't reviewed this product yet!"
		end
		redirect_to product_url(@product)
	end

  def watch_product
    @product = Product.find(params[:product_id])
    watched_product = Userwatchedproduct.where(product_id: @product.product_id, user_id: @current_user.user_id, store_product_id: nil).first
    if watched_product == nil
      watched_product = Userwatchedproduct.new
      watched_product.user_id = @current_user.user_id
      watched_product.product_id = @product.product_id
      watched_product.save
    end
    head :created
  end

  def unwatch_product
    @product = Product.find(params[:product_id])
    @watched_product = Userwatchedproduct.where(product_id: @product.product_id, user_id: @current_user.user_id, store_product_id: nil).first
    @watched_product.destroy if @watched_product != nil
    head :created
  end

	def compare
		@result = []
		@feature_keys = []
		@table={}
		@product_ids = []
		if(params.has_key?(:one) && params.has_key?(:two))
			arr = [params[:one], params[:two]]
			if(params.has_key?(:three))
				arr.push(params[:three])
			end

			if(params.has_key?(:four))
				arr.push(params[:four])
			end

			if(params.has_key?(:five))
				arr.push(params[:five])
			end
			
			for i in arr
				product = Product.find(i)
				@product_ids.push(product.product_id)
				product.features.each do |f|
					@feature_keys.push(f.feature_type)
					if !@table[f.feature_type]
						@table[f.feature_type] = {}
					end
					@table[f.feature_type][product.product_id] = f.feature_name
				end
				p = Product.find(i)
				@result.push(p)

			end
			@feature_keys = @feature_keys.to_set
			@product_ids = @product_ids.to_set
			
		end

		puts "table"
		puts @table
		render layout: "popup" 
	
	end
	private
		def parse_neo(node)
			puts "Node"
			ret={}
			node.keys.each do |name|
				ret[name] = {"dbid"=> node[name].keys.first, "factor"=> node[name][node[name].keys.first].keys.first}
			end
			return ret

		end

		def with_children(node)
		  if node[node.keys.first].keys.first.is_a?(Integer)
		    { "name" => node.keys.first,
		      "size" => 1 + node[node.keys.first].keys.first 
		     }
		  else
		    { "name" => node.keys.first, 
		      "children" => node[node.keys.first].collect { |c| 
		        with_children(Hash[c[0], c[1]]) } 
		    }
		  end
		end

end
