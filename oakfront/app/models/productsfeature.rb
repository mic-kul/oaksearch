class Productsfeature < ActiveRecord::Base
    self.table_name = 'PRODUCT_FEATURES'
    self.primary_key = 'PROD_FEAT_ID'
    belongs_to :product
    belongs_to :feature

    #before_save :audit_update
    #before_create :audit_update
    def audit_update
      self.modified_date = DateTime.now
      if self.created_date.blank?
        self.created_date = DateTime.now
      end
    end
end