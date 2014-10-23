class Review < ActiveRecord::Base

  self.table_name = 'REVIEWS'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'REVIEW_ID_SEQ'

  belongs_to :product
  belongs_to :user

  before_create :date_update
  before_save :save_action

  validates :product_id, :uniqueness => { :scope => :user_id, :message=> "You have already reviewed this product!" }
  def date_update
  	self.created_date = DateTime.now
  end

  def save_action
  	self.rating = self.rating.to_int
  end
end
