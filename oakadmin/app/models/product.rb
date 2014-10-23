class Product < ActiveRecord::Base

    self.table_name = 'PRODUCTS'
    #self.primary_key = 'PRODUCT_ID'
    self.sequence_name = 'PRODUCT_ID_SEQ'

  validates :name, presence: true, length: {minimum: 2}
  validates :description, presence: true, length: {minimum: 2}

  has_many :productsfeatures
  has_many :features, :through => :productsfeatures

  has_many :productphotos
  has_many :photos, :through => :productphotos
  
  self.per_page = 15
  accepts_nested_attributes_for :features

  belongs_to :creator, class_name: "Admin", foreign_key: "created_by"
  belongs_to :editor, class_name: "Admin", foreign_key: "modified_by"

  has_many :storeproducts
  has_many :stores, :through => :storeproducts


  #fill audit data
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
