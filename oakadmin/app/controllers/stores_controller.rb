class StoresController < ApplicationController
  before_filter :authenticate_user
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
    if @store.zip_code.length > 1
        @country = @store.zip_code[0..1]

        @store.zip_code = @store.zip_code[2..-1]
    end
  end

  # POST /stores
  # POST /stores.json
  def create
    paramz = store_params

    paramz[:zip_code] = [params[:country], store_params[:zip_code]].join("")
    @store = Store.new(paramz)
    @store.created_by = @current_user.admin_id

    respond_to do |format|
      if @store.save

        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render action: 'show', status: :created, location: @store }
      else
        if @store.zip_code.length > 1 && params[:country].length > 0
          @country = @store.zip_code[0..1]
          @store.zip_code = @store.zip_code[2..-1]
        end

        format.html { render action: 'new' }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    paramz = store_params
    if params[:country].length > 0
      paramz[:zip_code] = [params[:country], store_params[:zip_code]].join("")
    else
      paramz[:zip_code] = [params[:_country], store_params[:zip_code]].join("")
    end
    respond_to do |format|
      if @store.update(paramz)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { head :no_content }
      else
        if @store.zip_code.length > 1
            @country = @store.zip_code[0..1]

            @store.zip_code = @store.zip_code[2..-1]
        end
        format.html { render action: 'edit' }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params[:store].permit(:name, :street_address, :zip_code, :website, :store_id)
    end
end
