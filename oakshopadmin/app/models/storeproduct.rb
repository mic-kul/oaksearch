class Storeproduct < ActiveRecord::Base

  self.table_name = 'STORE_PRODUCTS'
  #self.primary_key = 'STORE_PRODUCT_ID'
  self.sequence_name = 'STORE_PRODUCT_ID_SEQ'

  validates :price, presence: true
  validates_uniqueness_of :product_id, :scope => :store_id

  belongs_to	:product
  belongs_to	:stores
end
