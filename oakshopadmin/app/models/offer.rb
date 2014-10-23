class Offer < ActiveRecord::Base

  self.table_name = 'OFFERS'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'OFFER_ID_SEQ'

  belongs_to :store
  belongs_to :auction

  before_create :set_date_offer

  validates :store_id, :uniqueness => { :scope => :auction_id, :message=> " had already offered in this price quotation!" }

  def set_date_offer
  	self.offer_date = DateTime.now
  end


end
