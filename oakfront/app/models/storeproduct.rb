class Storeproduct < ActiveRecord::Base

  self.table_name = 'STORE_PRODUCTS'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'STORE_PRODUCT_ID'

  belongs_to :store
  belongs_to :product

end
