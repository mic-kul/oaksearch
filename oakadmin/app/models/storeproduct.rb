class Storeproduct < ActiveRecord::Base

  self.table_name = 'STORE_PRODUCTS'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'STORE_PRODUCT_ID_SEQ'

  validates :price, presence: true

  belongs_to	:products
  belongs_to	:stores
end
