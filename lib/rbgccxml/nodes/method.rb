module RbGCCXML
  # Node type represending <Method ...> nodes, which are representation
  # of class methods.
  class Method < Function

    # Is this method static?
    def static?
      @node.attributes["static"] == "1"
    end
  end
end
