class Storeticket < ActiveRecord::Base

  self.table_name = 'TICKET_U_S'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'TICKET_US_ID_SEQ'

  before_create :date_update

  def date_update
  	self.datetime = Time.now
  end
end
