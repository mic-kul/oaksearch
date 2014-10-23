module Oak
  class Expression < Treetop::Runtime::SyntaxNode
    def to_cypher
      puts "EXPRESSION"
      puts self.elements[0].to_cypher
      cypher_hash =  self.elements[0].to_cypher
      cypher_string = ""
      cypher_string << "START "   + cypher_hash[:start].uniq.join(", ")
      cypher_string << " MATCH "  + cypher_hash[:match].uniq.join(", ") unless cypher_hash[:match].empty?
      cypher_string << " RETURN DISTINCT " + cypher_hash[:return].uniq.join(", ")
      params = cypher_hash[:params].empty? ? {} : cypher_hash[:params].uniq.inject {|a,h| a.merge(h)}
      return [cypher_string, params].compact
    end
  end
  
  class Body < Treetop::Runtime::SyntaxNode
    def to_cypher
      puts "BODY"
      cypher_hash = Hash.new{|h, k| h[k] = []}
      self.elements.each do |x|
        x.to_cypher.each do |k,v|
          cypher_hash[k] << v
        end
      end
      return cypher_hash
    end
  end

  class Gadget < Treetop::Runtime::SyntaxNode
    def to_cypher
        puts "GADGET"
        return {:start => "me = node({me})", 
                :return => "me",
                :params => {"me" => nil }}
    end 
  end

  class Feature < Treetop::Runtime::SyntaxNode
    def to_cypher
        puts "  Feature"
        puts self.elements
        puts  self.text_value
        return {:start  => "feature = node:features({feature})",
                :params => {"feature" => "name: " + self.text_value } }
    end 
  end

  class HasFeature < Treetop::Runtime::SyntaxNode
    def to_cypher
        puts "    HAS FEATURE"
        puts self.elements
        puts  self.text_value
        return {:match => "gadget -[:has]-> feature"}
    end 
  end


  class HasFeatureAnd < Treetop::Runtime::SyntaxNode
    def to_cypher
        puts "    HAS FEATURE AND"
        puts self.elements
        puts  self.text_value
        return {:start  => "feature1 = node:features({feature1}), feature2 = node:features({feature2})",
                :match  => "people -[:has]-> feature1, people -[:has]-> feature2",
                :params => {"feature1" => "name: " + self.elements[1].text_value, "feature2" => "name: " + self.elements.last.text_value} }
    end 
  end 
end