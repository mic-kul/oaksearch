class ProductsController < ApplicationController
  before_filter :authenticate_user
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all :include =>[:creator, :editor] 
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  def add_photo
    content_types=["image/png", "image/jpeg", "image/gif"]
    @product = Product.find(params[:id])
    @photos = Photo.find_by_sql(["SELECT p.photo_path, p.photo_id FROM product_photos x INNER JOIN PHOTOS p ON x.photo_id = p.photo_id WHERE x.product_id = ? ", @product.product_id])
     if !request.post?
      return
    end

    image = params[:uploaded_file]

    if !content_types.include?(image.content_type)
      flash[:error] = "Content type "+image.content_type+" is not allowed! Allowed: "+'"image/png", "image/jpeg", "image/gif"'
      redirect_to "/product_add_photo/#{@product.product_id}"
      return
    end
    time = Time.current
    name = time.to_formatted_s(:number) +"_"+image.original_filename
    directory = "/var/apps/oakfront/public/uploads"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(image.read) }
    flash[:notice] = "File uploaded"
    photo = Photo.new
    photo.photo_path = name
    photo.save

    pp = Productphoto.new
    pp.product_id = @product.product_id
    pp.photo_id = photo.photo_id
    pp.save
    redirect_to "/product_add_photo/#{@product.product_id}"
  end

  def delete_photo
    photo = Photo.find(params[:id])
    @photos = Photo.find_by_sql(["SELECT p.photo_path, p.photo_id, x.product_photo_id, x.product_id FROM product_photos x INNER JOIN PHOTOS p ON x.photo_id = p.photo_id WHERE x.photo_id = ? ", params[:id]]).first
    product_id = @photos.product_id
    product_photo = Productphoto.find(@photos.product_photo_id)
    product_photo.destroy
    photo.destroy
    flash[:notice] = "Successfully deleted requested photo"
    redirect_to "/product_add_photo/#{product_id}"
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.features.new
    @feature = Feature.new
    @productFeatures = @product.features
    @features = Feature.all
  end

  def features
    @features = @product.features
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @product.features.new
    @feature = Feature.new
    @features = Feature.where("feature_type != ?", "_name")
    @productFeatures = @product.features
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.created_by = @current_user.admin_id
    @product.modified_by = @current_user.admin_id
    puts product_params[:feature_ids]
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        @productFeatures = @product.features
        @features = Feature.all
        @feature = Feature.new
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      @product.modified_by = @current_user.admin_id
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :feature_ids =>[], features_attributes: [:feature_id, :feature_type, :feature_name])
    end
end
