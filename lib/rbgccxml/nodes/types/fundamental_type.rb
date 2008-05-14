module RbGCCXML

  # The FundamentalType. This represents all the built-in types
  # of C++ like int, double, char, etc.
  class FundamentalType < Type

    def to_s
      @node.attributes["name"]
    end
  end

end
