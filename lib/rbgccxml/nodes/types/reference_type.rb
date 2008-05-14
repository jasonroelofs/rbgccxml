module RbGCCXML
  class ReferenceType < Type

    def ==(val)
      check_sub_type_without(val, /\&/)
    end

    def to_s
      type = XMLParsing.find_type_of(self.node, "type")
      "#{type}&"
    end
  end
end
