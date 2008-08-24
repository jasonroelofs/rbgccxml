module RbGCCXML
  # Handles the FunctionType GCCXML node, which is the mapping
  # down to a Function Pointer.
  # While this class may be named Type, it behaves like a Node (aka, 
  # you can't get deeper in the type tree than this node).
  #
  # In terms of querying, this is exactly like a Function, for obvious reasons.
  class FunctionType < Function
  end
end
