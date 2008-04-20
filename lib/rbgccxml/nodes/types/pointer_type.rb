module RbGCCXML

  # This represents a Pointer of any other kind of type
  class PointerType < Type

    # Does this type match the given name string? 
    def ==(val)
      # Look for the '*' denoting a pointer type.
      # Assuming we find one, drop it and look for the
      # base type.
      return false unless val =~ /\*/
      new_val = val.gsub("*", "").strip
      XMLParsing.find_type_of(self.node, "type") == new_val
    end
  end

end
