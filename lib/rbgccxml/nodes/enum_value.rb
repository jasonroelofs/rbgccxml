module RbGCCXML
  # A specific value entry of an enumeration
  class EnumValue < Node

    # Link to the Enumeration Node that holds this EnumValue
    attr_accessor :parent

    # What is the C++ value of this enum entry?
    def value
      node.attributes["init"].to_i
    end

    # The qualified name of an Enum Value doesn't
    # include the name of the enum itself
    def qualified_name
      "#{self.parent.parent.qualified_name}::#{self.name}"
    end

  end
end
