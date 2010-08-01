module RbGCCXML
  # Represents the <Namespace> node. Namespaces can have in it
  # more namespaces, methods, classes, structs, attributes, ... everything.
  class Namespace < Node

    # Special case for the top-level namespace, ignore :: or
    # we get elements that print out as ::::type
    def qualified_name #:nodoc:
      if @name == "::"
        ""
      else
        super
      end
    end

    def to_cpp
      self.qualified_name
    end
  end
end
