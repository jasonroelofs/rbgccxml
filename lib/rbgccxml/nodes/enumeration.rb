module RbGCCXML
  class Enumeration < Node

    # True if the type is equal to the passed in string.
    # ex: enum.is_type?("Enumeration")
    def is_type?(type_name)
      type_name == to_s
    end

    # Get the list of Values for this enumeration
    def values
      XMLParsing.get_values_of(self).each {|v| v.parent = self }
    end

  end
end
