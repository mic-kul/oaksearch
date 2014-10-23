class Productphoto < ActiveRecord::Base
    self.table_name = 'PRODUCT_PHOTOS'
    #self.primary_key = 'PROD_FEAT_ID'
    self.sequence_name = 'PRODUCT_PHOTO_ID_SEQ'
    belongs_to :product
    belongs_to :photo

end