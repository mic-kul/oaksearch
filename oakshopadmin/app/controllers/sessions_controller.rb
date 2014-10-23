class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:logout]
  before_filter :save_login_state, :only => [:login, :try_login]
  def login
  end

  def logout
    session[:store_user_id] = nil
    flash[:notice] = "You have been logged out"
    redirect_to :root
  end

  def try_login
      puts "try login"
      authorized_user = Storeuser.authenticate(params[:username_or_email],params[:login_password])
      if authorized_user
        flash[:notice] = "Wow Welcome again, #{authorized_user.first_name}!"
        session[:store_user_id] = authorized_user.store_user_id
        redirect_to :root
      else
        flash[:error] = "Invalid Username or Password"
        render "login"  
      end
  end
end
