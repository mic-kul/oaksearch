class StoreusersController < ApplicationController
  before_filter :authenticate_user
  before_action :set_storeuser, only: [:show, :edit, :update, :destroy]

  # GET /storeusers
  # GET /storeusers.json
  def index
    @storeusers = Storeuser.all
  end

  # GET /storeusers/1
  # GET /storeusers/1.json
  def show
  end

  # GET /storeusers/new
  def new
    @stores = Store.all
    @storeuser = Storeuser.new
  end

  # GET /storeusers/1/edit
  def edit
    @stores = Store.all
  end

  # POST /storeusers
  # POST /storeusers.json
  def create
    puts params
    puts storeuser_params
    @storeuser = Storeuser.new(storeuser_params)
    respond_to do |format|
      if @storeuser.save
        format.html { redirect_to action: 'index', notice: 'Storeuser was successfully created.' }
        format.json { render action: 'show', status: :created, location: @storeuser }
      else
        @stores = Store.all
        format.html { render action: 'new' }
        format.json { render json: @storeuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /storeusers/1
  # PATCH/PUT /storeusers/1.json
  def update

    respond_to do |format|
      if @storeuser.update(storeuser_params)
        format.html { redirect_to @storeuser, notice: 'Storeuser was successfully updated.' }
        format.json { head :no_content }
      else
        @stores = Store.all
        format.html { render action: 'edit' }
        format.json { render json: @storeuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storeusers/1
  # DELETE /storeusers/1.json
  def destroy
    @storeuser.destroy
    respond_to do |format|
      format.html { redirect_to storeusers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_storeuser
      @storeuser = Storeuser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def storeuser_params
      params[:storeuser].permit(:nick, :first_name, :last_name, :email, :password, :store_id)
    end
end
