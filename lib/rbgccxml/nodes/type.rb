module RbGCCXML

  # The base class for all type management classes.
  class Type < Node

    # For types like pointers or references, we recursively track down
    # the base type when doing comparisons.
    #
    # delim needs to be a regex
    def check_sub_type_without(val, delim)
      return false unless val =~ delim
      new_val = val.gsub(delim, "").strip
      XMLParsing.find_type_of(self.node, "type") == new_val
    end

    # Is this type a const?
    def const?
      found = XMLParsing.find_type_of(self.node, "type")
      found ? found.const? : false
    end

  end

end
