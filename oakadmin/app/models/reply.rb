class Reply < ActiveRecord::Base

  self.table_name = 'REPLIES'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'REPLY_ID_SEQ'

  before_create :date_update

  def date_update
  	self.datetime = Time.now
  end
end
