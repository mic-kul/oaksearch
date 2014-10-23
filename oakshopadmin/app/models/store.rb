class Store < ActiveRecord::Base

	self.table_name = 'STORES'
	#self.primary_key = 'PRODUCT_ID'
	self.sequence_name = 'STORE_ID_SEQ'

	validates :name, presence: true, length: {in: 2..25}
	validates :website, presence: true, length: {in: 2..50}
	validates :street_address, presence: true, length: {in: 2..50}
	validates :zip_code, presence: true, length: {in: 2..5}


	has_many :storeproducts
	has_many :products, :through => :storeproducts

	before_save :audit_update
	before_create :audit_update
	def audit_update
		datenow = DateTime.now
		self.modified_date = datenow
		if self.created_date.blank?
		  self.created_date = datenow
		end
	end
end
