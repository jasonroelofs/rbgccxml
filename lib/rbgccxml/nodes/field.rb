module RbGCCXML

  # Represents a <Field> node, which is a Class's instance variable
  class Field < Node

    # Get the Node representing this field's type
    def cpp_type
      NodeCache.find(attributes["type"])
    end
    once :cpp_type

    # See Node#to_cpp
    def to_cpp(qualified = false)
      "#{self.cpp_type.to_cpp(qualified)} #{self.name}"
    end
    once :to_cpp

  end

end
