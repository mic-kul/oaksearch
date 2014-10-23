class Store < ActiveRecord::Base

  self.table_name = 'STORES'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'STORE_ID_SEQ'
  has_many :storeproducts
end
