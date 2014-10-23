class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_admin
  protected 
  	def set_admin
  		puts "check admin and set variable"
		if session[:store_user_id]
			puts 'session found'
		    @current_user = Storeuser.find session[:store_user_id]
		    puts @current_user.store_user_id
		end
  	end

	def authenticate_user
		puts "authenticate_user"
	  if session[:store_user_id]
	    @current_user = Storeuser.find session[:store_user_id]
	    puts @current_user
	    return true	
	  else
	  	puts "else redirect to login"
	    redirect_to(:controller => 'sessions', :action => 'login')
	    return false
	  end
	end

	def save_login_state
	  if session[:store_user_id]
	    redirect_to(:controller => 'home', :action => 'index')
	    return false
	  else
	    return true
	  end
	end
end
