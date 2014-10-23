class HomeController < ApplicationController
	before_filter :authenticate_user
	def index
	end

	def list_user_tickets
   	 @storetickets = Storeticket.find_by_sql(["SELECT t.*, u.nick FROM TICKET_U_S t 
      INNER JOIN USERS u ON t.user_id = u.user_id
      WHERE t.store_id = ? ORDER BY t.datetime DESC", @current_user.store_id])
    end

    def list_admin_tickets
    	@admintickets = Adminticket.find_by_sql(["SELECT t.* FROM TICKET_S_A t
      WHERE t.store_id = ? ORDER BY t.datetime DESC", @current_user.store_id])
    end

	def new_admin_ticket
		@admins = Admin.all
	end

	def new_admin_ticket_save
		puts "ok"
		@admins = Admin.all
	    @admin = Admin.find(params[:admin_id])
	    message = params[:message]
	    ticket = Adminticket.new
	    ticket.store_id = @current_user.store_id
	    ticket.admin_id = @admin.admin_id
	    ticket.message = message
	    ret = ticket.save
	    if(ret)
	    	puts "ok2"
	      flash[:notice] = "Your ticket has been sent"
	      redirect_to action: 'list_admin_tickets'
	      return
	    else
	    	puts "ok3"
	      flash[:error] = "Couldn't add ticket!"
	      render 'new_admin_ticket'
	    end
	end

	def show_admin_ticket
		@ticket = Adminticket.where(ticket_sa_id: params[:id], store_id: @current_user.store_id).first
		@replies = Adminticket.find_by_sql(["SELECT r.*, tr.* FROM TICKET_S_A_REPLY tr 
    INNER JOIN REPLIES r ON r.reply_id = tr.reply_id WHERE tr.ticket_sa_id = ? ", @ticket.ticket_sa_id])
	end

	def show_user_ticket
		@ticket = Storeticket.where(ticket_us_id: params[:id], store_id: @current_user.store_id).first
    	@replies = Storeticket.find_by_sql(["SELECT r.*, tr.* FROM TICKET_U_S_REPLY tr 
    INNER JOIN REPLIES r ON r.reply_id = tr.reply_id WHERE tr.ticket_us_id = ? ", @ticket.ticket_us_id])
	end

	def reply_user_ticket
		@ticket = Storeticket.where(ticket_us_id: params[:id], store_id: @current_user.store_id).first
		if !@ticket
			redirect_to action: 'list_user_tickets'
		end

		reply = Reply.new
	    reply.message = params[:reply]
	    reply.is_creator = 0
	    ret = reply.save
	    if ret
	        raw_sql = "INSERT INTO TICKET_U_S_REPLY (ticket_us_id, reply_id) VALUES (#{@ticket.ticket_us_id}, #{reply.reply_id})"
	        join = ActiveRecord::Base.connection.execute raw_sql
	        if join
	          flash[:notice] = "ticket reply saved"
	          redirect_to action: 'list_user_tickets'
	          return
	        else
	          flash[:error] = 'Could not add reply'
	          reply.destroy
	          render 'list_user_tickets'
	          return
	       end
	    else
	      flash[:error] = 'Could not add reply'
	      render 'list_user_tickets'
	    end
	end

	def reply_admin_ticket
		@ticket = Adminticket.where(ticket_sa_id: params[:id], store_id: @current_user.store_id).first
		if !@ticket
			redirect_to action: 'list_admin_tickets'
		end

		reply = Reply.new
	    reply.message = params[:reply]
	    reply.is_creator = 1
	    ret = reply.save
	    if ret
	        raw_sql = "INSERT INTO TICKET_S_A_REPLY (ticket_sa_id, reply_id) VALUES (#{@ticket.ticket_sa_id}, #{reply.reply_id})"
	        join = ActiveRecord::Base.connection.execute raw_sql
	        if join
	          flash[:notice] = "ticket reply saved"
	          redirect_to action: 'list_admin_tickets'
	          return
	        else
	          flash[:error] = 'Could not add reply'
	          reply.destroy
	          render 'list_admin_tickets'
	          return
	       end
	    else
	      flash[:error] = 'Could not add reply'
	      render 'list_admin_tickets'
	    end
	end
end
