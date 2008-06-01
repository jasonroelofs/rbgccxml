module RbGCCXML
  # Node type represending <Method ...> nodes, which are representation
  # of class methods.
  class Method < Function

    # Is this method static?
    def static?
      @node.attributes["static"] == "1"
    end
    
    # Is this a virtual method?
    def virtual?
      @node.attributes["virtual"] == "1"
    end
    
    # A purely virtual method has no body.
    def purely_virtual?
      @node.attributes["pure_virtual"] == "1"
    end
  end
end
