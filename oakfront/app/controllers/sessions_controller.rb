class SessionsController < ApplicationController
	before_filter :authenticate_user, :only => [:home, :profile, :setting]
	before_filter :save_login_state, :only => [:login, :try_login]
  def login
  end

  def home
  end

  def profile
  end

  def setting
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "You have been logged out"
    redirect_to :action => 'login'
  end

  def try_login
  	puts "try login"
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
      flash[:notice] = "Thank you for logging in #{authorized_user.first_name} #{authorized_user.last_name} (#{authorized_user.nick})!"
      session[:user_id] = authorized_user.user_id
      redirect_to '/'
    else
      flash[:error] = "Invalid Username or Password"
      render "login"	
    end
  end
end
