class Blacklist < ActiveRecord::Base

  self.table_name = 'BLACK_LISTS'
  self.sequence_name = 'BLACK_LIST_ID_SEQ'

end
