class OffersController < ApplicationController
  def index
  	@offers = Auction.find_by_sql(["SELECT a.*, p.*, u.nick FROM AUCTIONS a 
      INNER JOIN PRODUCTS p ON p.PRODUCT_ID = a.PRODUCT_ID 
      INNER JOIN USERS u ON a.USER_ID = u.user_id
      LEFT JOIN BLACK_LISTS bl ON bl.user_id = u.user_id
      LEFT JOIN BLACK_LIST_STORES bls ON bls.store_id = ?
      WHERE a.END_DATE > ?", @current_user.store_id, DateTime.current])
  end

  def show
  	@pval = ''
  	@mval = ''
  	@offer = Auction.find_by_sql(["SELECT a.*, p.*, u.nick FROM AUCTIONS a INNER JOIN PRODUCTS p ON p.PRODUCT_ID = a.PRODUCT_ID INNER JOIN USERS u ON a.USER_ID = u.user_id WHERE a.END_DATE > ? AND a.auction_id = ?", DateTime.current, params[:id]]).first
    @shopoffer = Offer.new

  end

  def make_offer
  end

  def make_offer_save
  	@offer = Auction.find_by_sql(["SELECT a.*, p.*, u.nick FROM AUCTIONS a INNER JOIN PRODUCTS p ON p.PRODUCT_ID = a.PRODUCT_ID INNER JOIN USERS u ON a.USER_ID = u.user_id WHERE a.END_DATE > ? AND a.auction_id = ?", DateTime.current, params[:id]]).first
  	@shopoffer = Offer.new
  	@shopoffer.store_id = @current_user.store_id
  	@shopoffer.auction_id = @offer.auction_id
  	@shopoffer.offer_date = DateTime.current
  	@shopoffer.price = params[:price]
  	@shopoffer.offer = params[:offer]
  	@pval = ''
  	@mval = ''
  	@pval = params[:price] if params[:price]
  	@mval = params[:offer] if params[:offer]
  	respond_to do |format|
      if @shopoffer.save
        format.html { redirect_to '/offers/index', notice: 'Offer was successfully added. Please wait patinetly for contact from client.' }
      else
        format.html { render action: 'show' }
      end
    end


  end
end
