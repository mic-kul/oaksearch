class Feature < ActiveRecord::Base

    self.table_name = 'FEATURES'
    #self.primary_key = 'PRODUCT_ID'
    self.sequence_name = 'FEATURE_ID_SEQ'

  validates :feature_name, presence: true
  validates :feature_type, presence: true, length: {minimum: 3}

  has_many :productsfeatures
  has_many :products, :through => :productsfeatures

  belongs_to :admin



  before_save :audit_update
  before_create :audit_update
  def audit_update
    self.modified_date = DateTime.now
    if self.created_date.blank?
      self.created_date = DateTime.now
    end
  end

  def type_with_value
    " #{feature_type}: #{feature_name} "
  end
end
