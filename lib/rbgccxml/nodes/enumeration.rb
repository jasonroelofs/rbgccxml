module RbGCCXML

  # Represents an <Enumeration> node.
  # Has many <EnumValue> nodes.
  class Enumeration < Node

    # Get the list of EnumValues for this enumeration
    def values
      XMLParsing.get_values_of(self).each {|v| v.parent = self }
    end

    # Is this enumeration anonymous? As in, does it have a name or is
    # it just a pretty wrapper around constant values, ala:
    #
    #   enum {
    #     VALUE1,
    #     VALUE2,
    #     ...
    #   };
    #
    def anonymous?
      # The given GCC-XML name of an anon Enum is ._[number]. We don't care what
      # that number is, only that the name matches this format
      self.name =~ /\._\d+/
    end

  end

end
