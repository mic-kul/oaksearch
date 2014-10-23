class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_admin
  protected 
  	def set_admin
		if session[:admin_id]
		    @current_user = Admin.find session[:admin_id]
		end
  	end

	def authenticate_user
	  if session[:admin_id]
	    @current_user = Admin.find session[:admin_id]
	    return true	
	  else
	    redirect_to(:controller => 'sessions', :action => 'login')
	    return false
	  end
	end

	def save_login_state
	  if session[:admin_id]
	    redirect_to(:controller => 'dashboard', :action => 'index')
	    return false
	  else
	    return true
	  end
	end
end
