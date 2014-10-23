class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_user
  add_breadcrumb "home", :root_path
  around_filter :catch_not_found


	def catch_not_found
	  yield
	rescue ActiveRecord::RecordNotFound
	  redirect_to root_url, :flash => { :error => "Record not found." }
	end
  protected 
  	def set_user 
  		puts "setuser"
		if session[:user_id]
		    @current_user = User.find session[:user_id]
		end
  	end
	def authenticate_user
		puts "authenticate_user"
	  if session[:user_id]
	    @current_user = User.find session[:user_id]
	    puts @current_user
	    return true	
	  else
	  	puts "else redirect to login"
	    redirect_to(:controller => 'sessions', :action => 'login')
	    return false
	  end
	end
	def save_login_state
	  if session[:user_id]
	    redirect_to(:controller => 'sessions', :action => 'home')
	    return false
	  else
	    return true
	  end
	end
end
