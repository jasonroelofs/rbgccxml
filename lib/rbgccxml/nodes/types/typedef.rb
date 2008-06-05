module RbGCCXML

  # This represents a Typedef, basically the renaming of one type to
  # another.
  class Typedef < Type
    # Checks the typedef base type as well.
    def is_type?(type_name)
      points_to = XMLParsing.find_type_of(self.node, "type")
      (points_to.is_a?(Type) && points_to.is_type?(type_name)) || super(type_name)
    end
  end

end
