module RbGCCXML
  # A specific value entry of an enumeration
  class EnumValue < Node

    # What is the C++ value of this enum entry?
    def value
      node.attributes["init"].to_i
    end
  end
end
