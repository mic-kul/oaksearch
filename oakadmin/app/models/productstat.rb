class Productstat
  include Mongoid::Document
  field :visit, type: BigDecimal
  field :product, type: BigDecimal
  field :date, type: String

  def self.get_popular
	  map = "
	    function () {
	      emit(this.product, {'visit' : this.visit});
	    }
	  "

	  reduce = "
	    function (key, emits) {
	      var total = {'visit' : 0};
	      for (var i in emits) {
	        total.visit  += emits[i].visit;
	      }
	      return total;
	    }
	  "
	self.all.map_reduce(map, reduce).out(inline: true).to_a
	end
end