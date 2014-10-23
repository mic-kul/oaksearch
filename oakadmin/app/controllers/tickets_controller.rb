class TicketsController < ApplicationController
	def list_user_tickets
   	 @usertickets = Adminticket.find_by_sql(["SELECT t.*, u.nick FROM TICKET_U_A t 
      INNER JOIN USERS u ON t.user_id = u.user_id
      WHERE t.admin_id = ? ORDER BY t.datetime DESC", @current_user.admin_id])
    end

    def list_store_tickets
    	@storetickets = Storeticket.find_by_sql(["SELECT t.*, s.name FROM TICKET_S_A t
    	INNER JOIN STORES s ON s.store_id = t.store_id
      WHERE t.admin_id = ? ORDER BY t.datetime DESC", @current_user.admin_id])
    end

    def show_store_ticket
    	@ticket = Storeticket.where(ticket_sa_id: params[:id], admin_id: @current_user.admin_id).first
    	@replies = Storeticket.find_by_sql(["SELECT r.*, tr.* FROM TICKET_S_A_REPLY tr 
    	INNER JOIN REPLIES r ON r.reply_id = tr.reply_id WHERE tr.ticket_sa_id = ? ", @ticket.ticket_sa_id])
    end

    def show_user_ticket
    	@ticket = Adminticket.where(ticket_ua_id: params[:id], admin_id: @current_user.admin_id).first
    	@replies = Storeticket.find_by_sql(["SELECT r.*, tr.* FROM TICKET_U_A_REPLY tr 
    	INNER JOIN REPLIES r ON r.reply_id = tr.reply_id WHERE tr.ticket_ua_id = ? ", @ticket.ticket_ua_id])
    end

 	def reply_user_ticket
    	@ticket = Adminticket.where(ticket_ua_id: params[:id], admin_id: @current_user.admin_id).first
		if !@ticket
			redirect_to action: 'list_user_tickets'
		end

		reply = Reply.new
	    reply.message = params[:reply]
	    reply.is_creator = 0
	    ret = reply.save
	    if ret
	        raw_sql = "INSERT INTO TICKET_U_A_REPLY (ticket_ua_id, reply_id) VALUES (#{@ticket.ticket_ua_id}, #{reply.reply_id})"
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



   def reply_store_ticket
    	@ticket = Storeticket.where(ticket_sa_id: params[:id], admin_id: @current_user.admin_id).first
		if !@ticket
			redirect_to action: 'list_user_tickets'
		end

		reply = Reply.new
	    reply.message = params[:reply]
	    reply.is_creator = 0
	    ret = reply.save
	    if ret
	        raw_sql = "INSERT INTO TICKET_S_A_REPLY (ticket_sa_id, reply_id) VALUES (#{@ticket.ticket_sa_id}, #{reply.reply_id})"
	        join = ActiveRecord::Base.connection.execute raw_sql
	        if join
	          flash[:notice] = "ticket reply saved"
	          redirect_to action: 'list_store_tickets'
	          return
	        else
	          flash[:error] = 'Could not add reply'
	          reply.destroy
	          render 'list_store_tickets'
	          return
	       end
	    else
	      flash[:error] = 'Could not add reply'
	      render 'list_store_tickets'
	    end
    end
end
