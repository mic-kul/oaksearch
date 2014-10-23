class ZipcodesController < ApplicationController
  before_action :set_zipcode, only: [:show, :edit, :update, :destroy]

  # GET /zipcodes
  # GET /zipcodes.json
  def index
    @zipcodes = Zipcode.all
  end

  # GET /zipcodes/1
  # GET /zipcodes/1.json
  def show
  end

  # GET /zipcodes/1/edit
  def edit
   

  end

  # PATCH/PUT /zipcodes/1
  # PATCH/PUT /zipcodes/1.json
  def update

      if @zipcode.zip_code != zipcode_params[:zip_code]
        store =  Store.where(:zip_code => @zipcode.zip_code).first
        if store
          flash[:error] = "there is store using this zipcode. Modify it first!"
          redirect_to action: 'index'
          return
        end

        user  = User.where(:zip_code => @zipcode.zip_code).first
        if user
          flash[:error] = "there is user using this zipcode. Modify it first!"
          redirect_to action: 'index'
          return
        end
      end
    respond_to do |format|

      if @zipcode.update(zipcode_params)
        format.html { redirect_to @zipcode, notice: 'Zipcode was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @zipcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zipcodes/1
  # DELETE /zipcodes/1.json
  def destroy
    @zipcode.destroy
    respond_to do |format|
      format.html { redirect_to zipcodes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zipcode
      puts params[:id]
      @zipcode = Zipcode.where(:zip_code => params[:id]).first
      @zipcode.id = @zipcode.zip_code if @zipcode
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def zipcode_params
      params.permit(:zip_code, :city, :country)
    end
end
