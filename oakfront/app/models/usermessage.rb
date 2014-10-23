class Usermessage < ActiveRecord::Base

  self.table_name = 'USER_MESSAGE'
  #self.primary_key = 'PRODUCT_ID'
  #self.sequence_name = 'MESSAGE_ID_SEQ'

  belongs_to :user, :foreign_key => 'TO_USER'


end
