class Review < ActiveRecord::Base

  self.table_name = 'REVIEWS'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'REVIEW_ID_SEQ'

  belongs_to :product
  belongs_to :user
end
