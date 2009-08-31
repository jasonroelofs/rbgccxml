module RbGCCXML
  # Node that represents <ArrayType>, which is any static array
  # declaration.
  # One oddity on how GCCXML parses certain array designations:
  #  
  #   void func(int in[4][3]);
  #
  # will be parsed out as
  #
  #   void func(int* in[3]);
  #
  # aka, a pointer to a 3-element array, so keep this in mind when doing
  # comparisons or wondering why the to_cpp output is so odd
  class ArrayType < Type
    def ==(val)
      check_sub_type_without(val, /\[\d\]/)
    end

    def to_cpp(qualified = true)
      type = XMLParsing.find_type_of(self.node, "type")
      "#{type.to_cpp(qualified)}[#{self.node.attributes["max"].gsub(/[^\d]/, '').to_i + 1}]"
    end

  end
end
