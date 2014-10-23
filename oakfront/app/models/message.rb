class Message < ActiveRecord::Base

  self.table_name = 'MESSAGES'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'MESSAGE_ID_SEQ'

  belongs_to :user, :foreign_key => 'FROM_USER'


end
