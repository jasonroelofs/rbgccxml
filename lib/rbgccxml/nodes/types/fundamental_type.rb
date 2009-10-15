module RbGCCXML

  # Represents a <FundamentalType>. This represents all the built-in types
  # of C++ like int, double, char, etc.
  class FundamentalType < Type

    # We are base types. There's nothing
    # more to find once we've gotten to this type.
    def base_type #:nodoc:
      self
    end

  end

end
