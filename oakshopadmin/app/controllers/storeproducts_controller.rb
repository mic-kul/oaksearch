class StoreproductsController < ApplicationController
	def index
		#@storeproducts = Storeproduct.select("PRODUCTS.*, STORE_PRODUCTS.*").joins("LEFT JOIN ""PRODUCTS"" ON PRODUCTS.PRODUCT_ID = STORE_PRODUCTS.PRODUCT_ID").where(store_id: @current_user.store_id)
		@storeproducts = Storeproduct.find_by_sql(["SELECT p.*,  sp.* FROM STORE_PRODUCTS sp 
			LEFT JOIN PRODUCTS p ON p.PRODUCT_ID = sp.PRODUCT_ID WHERE sp.STORE_ID = ?", @current_user.store_id])	
	end

	def new
		@storeproduct = Storeproduct.new
		@products = Product.all
	end
	def show
	end

	def edit
		@storeproduct = Storeproduct.find_by_sql(["SELECT p.*,  sp.* FROM STORE_PRODUCTS sp 
			LEFT JOIN PRODUCTS p ON p.PRODUCT_ID = sp.PRODUCT_ID WHERE sp.STORE_ID = ? AND sp.store_product_id = ?", @current_user.store_id, params[:id]]).first
	end

	def update
		
		@storeproduct = Storeproduct.find_by_sql(["SELECT p.*,  sp.* FROM STORE_PRODUCTS sp 
			LEFT JOIN PRODUCTS p ON p.PRODUCT_ID = sp.PRODUCT_ID WHERE sp.STORE_ID = ? AND sp.store_product_id = ?", @current_user.store_id, params[:id]]).first
		respond_to do |format|
			if @storeproduct.update(:price => params[:storeproduct][:price])
				puts "OK"
				format.html { redirect_to '/storeproducts', notice: 'Price was successfully updated.' }
			else
				puts "Error"
				puts @storeproduct.errors.full_messages
				format.html {redirect_to '/storeproducts', notice: @storeproduct.errors.full_messages.first}
			end
		end

	end
	def create
		@storeproduct = Storeproduct.new
		@storeproduct.store_id = @current_user.store_id
		@storeproduct.price = params[:storeproduct][:price]
		@storeproduct.product_id = params[:product_id]
		respond_to do |format|
		if @storeproduct.save
			puts "OK"
			format.html { redirect_to '/storeproducts', notice: 'Store product was successfully created.' }
			format.json { render action: 'index', status: :created, location: "/storeproducts" }
		else
			puts "Error"
			puts @storeproduct.errors.full_messages
			format.html {redirect_to '/storeproducts/new', notice: @storeproduct.errors.full_messages.first}
		end
    end
	end
end
