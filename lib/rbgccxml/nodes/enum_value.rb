module RbGCCXML

  # Represents an <EnumValue> node, which is an entry in an <Enumeration>
  class EnumValue < Node

    # Get the defined value of this EnumValue
    def value
      attributes["init"].to_i
    end

    # The qualified name of an EnumValue doesn't
    # include the name of the enum itself
    def qualified_name #:nodoc:
      "#{self.parent.parent.qualified_name}::#{self.name}"
    end
    once :qualified_name

  end

end
