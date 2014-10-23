class AdminsController < ApplicationController
	before_filter :authenticate_user

	def new
		@admin = Admin.new 
	end

	def create
		@admin = Admin.new(admin_params)
		if @admin.save
			flash[:notice] = "Admin account created successfuly"
			redirect_to action: 'index'
			return
		else
			flash[:error] = "Form is invalid"
		end
		render "new"
	end

	def index
		@admins = Admin.all
	end

	def show
		@admin = Admin.find(params[:id])
	end

	def edit
		@admin = Admin.find(params[:id])
	end

	def update
		@admin = Admin.find(params[:id])
		update_params = admin_params
		
		if params[:admin][:password].strip.length != 0
			if params[:admin][:password] != params[:admin][:password_confirmation]
				flash[:error] = "Passwords do not match"
				redirect_to action: 'index'
			end
			puts "password present"
			update_params[:password_hash] =  BCrypt::Engine.hash_secret(params[:password], @admin.password_salt)
		end

		if @admin.update(update_params)
			flash[:notice] = "Admin updated"
			redirect_to action: 'index'
		else
			flash[:notice] = "Form errors"
			render action: 'edit'
		end
	end

	def destroy
			@admin = Admin.find(params[:id])
			if @admin.admin_id == @current_user.admin_id
				flash[:error] = "You cannot remove your account!"
				redirect_to action: 'index'
				return
			end

			@admin.destroy
			flash[:notice] = "Admin account removed!"
			redirect_to action: 'index'
	end

  private

	  def admin_params
	    params.require(:admin).permit(:nick,:first_name,:last_name, :email, :password)
	  end

end
