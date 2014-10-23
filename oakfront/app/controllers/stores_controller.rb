class StoresController < ApplicationController
	before_filter :authenticate_user, :only =>[:add_to_blacklist, :remove_from_blacklist]
	
	add_breadcrumb "stores", :stores_index_path

	def index
		@stores = Store.all
	end
	 
	def show
		@store = Store.find(params[:id])
		storestat = Storestat.where(:store => @store.store_id, :date => Date.today.to_s(:db)).first_or_create
		storestat.inc :visit => 1
		storestat.save

		@storeproducts = Storeproduct.where(:store_id => @store.store_id)
		@blacklisted=[]
		if @current_user
			@blacklisted = Blacklist.find_by_sql(["SELECT bl.*, bls.* FROM BLACK_LISTS bl INNER JOIN BLACK_LIST_STORES bls ON bls.black_list_id = bl.black_list_id WHERE bls.store_id = ? and bl.user_id = ?", params[:id], @current_user.user_id])
		end
	end


	def store_product
		@storeproduct = Storeproduct.find(params[:id])
	end

	def add_to_blacklist
		@store = Store.find(params[:id])
		bl = Blacklist.new
		bl.user_id = @current_user.user_id
		bl.created_date = Time.now
		bl.save

		bls = Blackliststore.new
		bls.black_list_id = bl.black_list_id
		bls.store_id = @store.store_id
		bls.save
		head :created
	end

	def remove_from_blacklist
		bl = Blacklist.find_by_sql(["SELECT bl.black_list_id, bls.black_list_store_id FROM BLACK_LISTS bl 
			INNER JOIN BLACK_LIST_STORES bls ON bls.black_list_id = bl.black_list_id WHERE bls.store_id = ? and bl.user_id = ?", params[:id], @current_user.user_id]).first
		
		blackL = Blacklist.find(bl.black_list_id)
		blackLS = Blackliststore.find(bl.black_list_store_id)
		blackLS.destroy
		blackL.destroy
		head :created
	end
end
