class StoreusersController < ApplicationController
  before_filter :authenticate_user
  before_action :set_storeuser, only: [:show, :edit, :update, :destroy]

  # GET /storeusers
  # GET /storeusers.json
  def index
    @storeusers = Storeuser.where(:store_id=>@current_user.store_id)
  end

  # GET /storeusers/1
  # GET /storeusers/1.json
  def show
  end

  # GET /storeusers/new
  def new
    @storeuser = Storeuser.new
    @storeuser.store_id = @current_user.store_id
  end

  # GET /storeusers/1/edit
  def edit
  end

  # POST /storeusers
  # POST /storeusers.json
  def create
    @storeuser = Storeuser.new(storeuser_params.except(:password_repeat))
    @storeuser.store_id = @current_user.store_id
    puts @storeuser
    respond_to do |format|
      if @storeuser.save
        flash[:notice] = 'Storeuser was successfully created.'
        format.html { redirect_to action: 'index', notice: 'Storeuser was successfully created.' }
        format.json { render action: 'index', status: :created, location: @storeuser }
      else
        format.html { render action: 'new' }
        format.json { render json: @storeuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /storeusers/1
  # PATCH/PUT /storeusers/1.json
  def update

    respond_to do |format|
      if @storeuser.update(storeuser_params.except(:password_repeat))
        flash[:notice] = "Storeuser was successfully updated."
        format.html { redirect_to action: 'index', notice: 'Storeuser was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @storeuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storeusers/1
  # DELETE /storeusers/1.json
  def destroy
  	if @storeuser.store_id == @current_user.store_id
	    @storeuser.destroy
	    respond_to do |format|
	      format.html { redirect_to storeusers_url }
	      format.json { head :no_content }
	    end
	end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_storeuser
      @storeuser = Storeuser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def storeuser_params
      params[:storeuser].permit(:nick, :first_name, :last_name, :email, :password, :password_repeat)
    end
end
