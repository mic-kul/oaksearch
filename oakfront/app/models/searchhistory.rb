class Searchhistory
  include Mongoid::Document
  field :user, type: BigDecimal
  field :date, type: String
  field :timestamp, type: BigDecimal
  field :query, type: String
  field :count, type: BigDecimal

end