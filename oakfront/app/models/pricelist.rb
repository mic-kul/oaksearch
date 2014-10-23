class Pricelist < ActiveRecord::Base

  self.table_name = 'PRICE_LIST'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'PRICE_LIST_ID_SEQ'
end
