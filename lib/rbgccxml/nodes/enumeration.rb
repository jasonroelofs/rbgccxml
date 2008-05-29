module RbGCCXML
  class Enumeration < Node

    # Get the list of Values for this enumeration
    def values
      XMLParsing.get_values_of(self).each {|v| v.parent = self }
    end

  end
end
