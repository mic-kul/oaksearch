class Auction < ActiveRecord::Base

  self.table_name = 'AUCTIONS'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'AUCTION_ID_SEQ'

  belongs_to :product
  belongs_to :user

  has_many :offers

  before_create :set_start_date
  validates :product_id, :uniqueness => { :scope => :user_id, :message=> "You already have asked for this product!" }
  validates :message, :presence => true


  def set_start_date
  	self.start_date = DateTime.now
    self.auction_status = "STARTED"
  end

end
