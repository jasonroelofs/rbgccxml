module RbGCCXML

  # Represents a <Constructor> node.
  #
  # Constructors act like functions except they don't have
  # a return value
  class Constructor < Function

    # Disabled: Constructors do not have a return_type.
    def return_type
      raise "There is no return_type of a constructor"
    end

  end

end
