module RbGCCXML
  class Enumeration < Node

    # Get the list of Values for this enumeration
    def values
      XMLParsing.get_values_of(self)
    end

  end
end
