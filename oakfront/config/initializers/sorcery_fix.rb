
module Model
  module Adapters
    module Mongoid
      module InstanceMethods
        def increment(attr)
          self.inc("#{attr}" => 1)
        end
      end
    end
  end
end
