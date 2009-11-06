module RbGCCXML

  # Represents a <Method>, which are class instance methods.
  class Method < Function

    # Is this method static?
    def static?
      @node["static"] == "1"
    end

    # Is this a virtual method?
    def virtual?
      @node["virtual"] == "1"
    end

    # Is this a pure virtual method? A purely virtual method has no body.
    def purely_virtual?
      @node["pure_virtual"] == "1"
    end

  end

end
