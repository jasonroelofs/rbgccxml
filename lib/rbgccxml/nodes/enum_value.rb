module RbGCCXML

  # Represents an <EnumValue> node, which is an entry in an <Enumeration>
  class EnumValue < Node

    # Link to the Enumeration that holds this EnumValue
    attr_accessor :parent

    # Get the defined value of this EnumValue
    def value
      node["init"].to_i
    end

    # The qualified name of an EnumValue doesn't
    # include the name of the enum itself
    def qualified_name #:nodoc:
      "#{self.parent.parent.qualified_name}::#{self.name}"
    end

  end

end
