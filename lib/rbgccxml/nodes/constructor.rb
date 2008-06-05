module RbGCCXML
  # Class representing <Constructor ...> nodes.
  # Has arguments
  class Constructor < Function
    # Constructors do not have a return_type, this raises an
    # exception.
    def return_type
      raise "There is no return_type of a constructor"
    end
  end
end
