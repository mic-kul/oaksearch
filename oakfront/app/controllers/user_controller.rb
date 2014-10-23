class UserController < ApplicationController
	before_filter :save_login_state, :only => [:new, :create]
	before_filter :authenticate_user, :only => [:show, :watched_products, :index, :price_offer, :price_offers,
                                                :edit_profile, :change_password, :list_messages, :save_message]
  def new
  	@user = User.new
  end

  def show
  end

  def index
     add_breadcrumb "profile", :user_index_path
  end

  def watched_products
    add_breadcrumb "profile", :user_index_path
    add_breadcrumb "watched products", :user_watched_products_path
  	@userwatchedproducts = Userwatchedproduct.where(user_id: @current_user.user_id)
  end

  def search_history
    add_breadcrumb "profile", :user_index_path
    add_breadcrumb "search history", :user_search_history_path

    @searchhistory = Searchhistory.where(user: @current_user.user_id)

  end

  #price offers list
  def price_offers
    add_breadcrumb "profile", :user_index_path
    add_breadcrumb "price offers", :user_price_offers_path
    @priceoffers = Auction.where(user_id: @current_user.user_id)
  end

  #single price offer
  def price_offer
    add_breadcrumb "profile", :user_index_path
    add_breadcrumb "price offers", :user_price_offers_path
    @auction = Auction.find_by_sql(["SELECT p.*, a.* FROM AUCTIONS a JOIN PRODUCTS p ON p.product_id = a.product_id WHERE a.USER_ID = ? AND a.AUCTION_ID = ? AND ROWNUM =1", @current_user.user_id, params[:id]]).first
    add_breadcrumb @auction.name, request.original_url
    @offers = Offer.find_by_sql(["SELECT s.*, o.* FROM OFFERS o JOIN STORES s ON o.store_id = s.store_id AND o.auction_id =? ", @auction.auction_id])
  end

  def edit_profile
    add_breadcrumb "profile", :user_index_path
    add_breadcrumb "edit profile", :user_edit_profile_path
    @user = User.find(@current_user.user_id)
    if request.post?
    	ret = @user.update(email: params[:email], street_address: params[:street_address])
      if ret
        flash[:notice] =  "Changes saved!"
    	  redirect_to action: 'index'
      else
        flash[:error] = "Form is invalid"
      end
    end
  end

  def change_password
    add_breadcrumb "profile", :user_index_path
    add_breadcrumb "change password", :user_change_password_path
    @user = User.find(@current_user.user_id)
    if request.post?
      if !@user.match_password params[:old_password]
        flash[:error] = "Invalid current password!"
        return
      end

      if params[:password].strip.length == 0
        flash[:error] = "New password cannot be empty!"
        return
      end

     if params[:password].strip.length < 8
        flash[:error] = "Password is too short! Minimal password length is 8 characters"
        return
      end

      if params[:password] != params[:password_confirmation]
        flash[:error] = "New password does not match password confirmation"
        return
      end

      ret = @user.update(password: params[:password])
      if ret
        flash[:notice] = "Password changed successfully"
        redirect_to action: 'index'
      else
        flash[:error] = "Password is invalid"
      end
    end
  end

  def create
    paramz = user_params
   
    paramz[:zip_code] = [params[:country], user_params[:zip_code]].join("")

		@user = User.new(paramz)
    if params[:country].length == 0
      flash[:error] = 'Country not selected!'
      render 'new'
      return
    end

		if @user.save
			flash[:notice] = "You signed up successfully and you have been logged in"
      session[:user_id] = @user.user_id
      redirect_to '/'
      return
		else
      if @user.zip_code.length > 1 && params[:country].length > 0
        @country = @user.zip_code[0..1]
        @user.zip_code = @user.zip_code[2..-1]
      end

			flash[:error] = "Form is invalid"
		end
		render "new"
  end

  def list_messages
    @messages = Message.find_by_sql(["SELECT m.*, um.*, u1.nick u_to, u2.nick u_from FROM MESSAGES m 
      INNER JOIN USER_MESSAGE um ON m.message_id = um.message_id 
      INNER JOIN USERS u1 ON u1.user_id = um.to_user
      INNER JOIN USERS u2 ON u2.user_id = m.from_user
      WHERE um.to_user = ? OR m.from_user = ? 
      ORDER BY SENT_DATE DESC", @current_user.user_id, @current_user.user_id])
    @message = Message.new
  end

  def list_messages_for
  end

  def save_message
    @user = User.find_by_nick(params[:recipient])
    if @user.blank?
      flash[:error] = 'User not found!'
      redirect_to action: 'list_messages'
      return
    end
    @message = Message.new
    @message.from_user = @current_user.user_id
    @message.message = params[:message]
    @message.save

    @user_message = Usermessage.new    
    @user_message.message_id = @message.message_id
    @user_message.to_user = @user.user_id
    @user_message.sent_date = Time.now
    @user_message.save

    redirect_to action: 'list_messages'
  end

  def list_tickets
    @storetickets = Storeticket.find_by_sql(["SELECT t.*, s.name FROM TICKET_U_S t 
      INNER JOIN STORES s ON t.store_id = s.store_id 
      WHERE t.user_id = ? ORDER BY t.datetime DESC", @current_user.user_id])
    @admintickets = Adminticket.find_by_sql(["SELECT t.* FROM TICKET_U_A t
      WHERE t.user_id = ? ORDER BY t.datetime DESC", @current_user.user_id])
  end

  def show_store_ticket
    @ticket = Storeticket.where(ticket_us_id: params[:id], user_id: @current_user.user_id).first
    @replies = Storeticket.find_by_sql(["SELECT r.*, tr.* FROM TICKET_U_S_REPLY tr 
    INNER JOIN REPLIES r ON r.reply_id = tr.reply_id WHERE tr.ticket_us_id = ? ", @ticket.ticket_us_id])
  end

  def reply_store_ticket
    @ticket = Storeticket.find(params[:id])
    reply = Reply.new
    reply.message = params[:reply]
    reply.is_creator = 1
    ret = reply.save
    if ret
        raw_sql = "INSERT INTO TICKET_U_S_REPLY (ticket_us_id, reply_id) VALUES (#{@ticket.ticket_us_id}, #{reply.reply_id})"
        join = ActiveRecord::Base.connection.execute raw_sql
        if join
          flash[:notice] = "ticket reply saved"
          redirect_to action: 'list_tickets'
          return
        else
          flash[:error] = 'Could not add reply'
          reply.destroy
          render 'list_tickets'
          return
       end
    else
      flash[:error] = 'Could not add reply'
      render 'list_tickets'
    end
  end

  def new_store_ticket
    
    if params[:id]
      @stores = Store.where(store_id: params[:id])
      @id = params[:id]
      puts @stores
    else
      @stores = Store.all
    end

  end

  def new_store_ticket_save
    @stores = Store.all
    @store = Store.find(params[:store_id])
    message = params[:message]
    ticket = Storeticket.new
    ticket.user_id = @current_user.user_id
    ticket.store_id = @store.store_id
    ticket.message = message
    ret = ticket.save
    if(ret)
      flash[:notice] = "Your ticket has been sent"
      redirect_to action: 'list_tickets'
      return
    else
      flash[:error] = "Couldn't add ticket!"
      render 'new_store_ticket'
    end
  end

  def show_admin_ticket
    @ticket = Adminticket.find(params[:id])
    @replies = Adminticket.find_by_sql(["SELECT r.*, tr.* FROM TICKET_U_A_REPLY tr 
    INNER JOIN REPLIES r ON r.reply_id = tr.reply_id WHERE tr.ticket_ua_id = ? ", @ticket.ticket_ua_id])
  end

  def reply_admin_ticket
    @ticket = Adminticket.find(params[:id])
    reply = Reply.new
    reply.message = params[:reply]
    reply.is_creator = 1
    ret = reply.save
    if ret
        raw_sql = "INSERT INTO TICKET_U_A_REPLY (ticket_ua_id, reply_id) VALUES (#{@ticket.ticket_ua_id}, #{reply.reply_id})"
        join = ActiveRecord::Base.connection.execute raw_sql
        if join
          flash[:notice] = "ticket reply saved"
          redirect_to action: 'list_tickets'
          return
        else
          flash[:error] = 'Could not add reply'
          reply.destroy
          render 'list_tickets'
          return
       end
    else
      flash[:error] = 'Could not add reply'
      render 'list_tickets'
    end
  end

  def new_admin_ticket
    @admins = Admin.all
  end

  def new_admin_ticket_save
    @admins = Admin.all
    @admin = Admin.find(params[:admin_id])
    message = params[:message]
    ticket = Adminticket.new
    ticket.user_id = @current_user.user_id
    ticket.admin_id = @admin.admin_id
    ticket.message = message
    ret = ticket.save
    if(ret)
      flash[:notice] = "Your ticket has been sent"
      redirect_to action: 'list_tickets'
      return
    else
      flash[:error] = "Couldn't add ticket!"
      render 'new_store_ticket'
    end
  end


	private
		# Never trust parameters from the scary internet, only allow the white list through.
		def user_params
		  params.require(:user).permit(:nick, :email, :password, :password_confirmation, :first_name, :last_name, :zip_code)
		end

    def user_edit_profile_params
      params.permit(:email, :zip_code, :street_address, :authenticity_token)
    end

    def user_change_password_params
      params.permit(:old_password, :password, :password_confirmation, :authenticity_token)
    end
end
