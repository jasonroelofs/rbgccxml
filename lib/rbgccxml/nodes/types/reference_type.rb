module RbGCCXML

  # References a <ReferenceType> node, which is a reference to another Type.
  class ReferenceType < Type

    def ==(val)
      check_sub_type_without(val, /\&/)
    end

    def to_cpp(qualified = true)
      type = NodeCache.find(attributes["type"])
      "#{type.to_cpp(qualified)}&"
    end
    once :to_cpp

  end

end
