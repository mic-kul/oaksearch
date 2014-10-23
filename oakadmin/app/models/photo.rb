class Photo < ActiveRecord::Base

    self.table_name = 'PHOTOS'
    #self.primary_key = 'PRODUCT_ID'
    self.sequence_name = 'PHOTO_ID_SEQ'


  has_many :productphotos
  has_many :products, :through => :productphotos
  

end
