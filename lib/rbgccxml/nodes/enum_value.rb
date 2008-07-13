module RbGCCXML
  # A specific value entry of an enumeration <EnumValue>
  class EnumValue < Node

    # Link to the Enumeration Node that holds this EnumValue
    attr_accessor :parent

    # Get the C++ value of the EnumValue
    def value
      node.attributes["init"].to_i
    end

    # The qualified name of an Enum Value doesn't
    # include the name of the enum itself
    def qualified_name #:nodoc:
      "#{self.parent.parent.qualified_name}::#{self.name}"
    end

  end
end
