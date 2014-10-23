class Storeticket < ActiveRecord::Base

  self.table_name = 'TICKET_S_A'
  #self.primary_key = 'PRODUCT_ID'
  self.sequence_name = 'TICKET_SA_ID_SEQ'

  before_create :date_update

  def date_update
  	self.datetime = Time.now
  end
end
