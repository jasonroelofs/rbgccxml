module RbGCCXML
  # Class representing <Constructor> nodes.
  class Constructor < Function
    # Disabled: Constructors do not have a return_type.
    def return_type
      raise "There is no return_type of a constructor"
    end
  end
end
