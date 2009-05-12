module RbGCCXML
  # Field is a class's Ivar
  class Field < Node

    # Get the C++ type of this argument.
    def cpp_type
      XMLParsing.find_type_of(node, "type")
    end

    # Print out the full string of this argument as given
    # in the source. If full == true, include the type information
    def to_s(full = false)
      str = self.name
      str = "#{self.cpp_type.to_s(true)} #{str}" if full
      str
    end

  end
end
