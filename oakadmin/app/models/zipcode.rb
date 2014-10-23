class Zipcode < ActiveRecord::Base

  self.table_name = 'ZIP_CODES'
  self.primary_key = 'ZIP_CODE'
  self.sequence_name = false

  validates :zip_code, presence: true, length: {minimum: 2, maximum: 10}

end
