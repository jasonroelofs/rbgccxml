module RbGCCXML

  # Represents a <Method>, which are class instance methods.
  class Method < Function

    # Is this method static?
    def static?
      attributes["static"] == "1"
    end

    # Is this a virtual method?
    def virtual?
      attributes["virtual"] == "1"
    end

    # Is this a pure virtual method? A purely virtual method has no body.
    def purely_virtual?
      attributes["pure_virtual"] == "1"
    end

  end

end
