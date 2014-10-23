class Userwatchedproduct < ActiveRecord::Base
  self.table_name = 'USER_WATCHED_PRODUCTS'
  self.sequence_name = "USER_WATCHED_PROD_ID_SEQ"

  belongs_to :product
  belongs_to :user

  before_create :audit_update
  def audit_update
  	self.user_watch_prod_date = DateTime.now
  end
end
