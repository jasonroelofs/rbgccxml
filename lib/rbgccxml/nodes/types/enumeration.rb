module RbGCCXML
  class Enumeration < Type

    # If we want the full name of the enumeration we'll need to trasverse the context heirarchy
    # and build it up ourselves.
    def to_s(full = false)
      if full
        full_name = self.name
        while(p = (p || self).parent)
          full_name = "#{p.name}::#{full_name}"
        end
        full_name
      else
        super
      end
    end
  end
end
