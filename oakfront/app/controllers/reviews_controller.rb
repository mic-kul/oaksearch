class ReviewsController < ApplicationController
  def index
  	@reviews = Review.all
  	add_breadcrumb "reviews", :reviews_path
  end

  def show
  	@review = Review.find(params[:id])
  	@otherProdRev = Review.where(product_id: @review.product_id).limit(5)
  	@otherUserRev = Review.where(user_id: @review.user_id).limit(5)
  	add_breadcrumb "reviews", :reviews_path
  	add_breadcrumb "review of #{@review.product.name} by #{@review.user.nick}", request.fullpath
  end
end
