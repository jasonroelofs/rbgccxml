module RbGCCXML
  # Any node query will return an instance of this class, QueryResult. This 
  # class is an Array with slightly different handling of #find. Array#find
  # expects a block to find elements, we want #find to take an options
  # hash.
  class QueryResult < Array

    # Find within this result set any nodes that match the given options
    # Options can be any or all of the following, based on the type of node:
    # 
    # All nodes:
    # <tt>:name</tt>::        The unmangled name of the node. Can be a string or Regexp. Works on all nodes.
    # <tt>:arguments</tt>::   Search according to argument types. 
    #                         This needs to be an array of strings or symbols. nil can be
    #                         used as a "any" flag. Only works on Functions, Methods, and Constructors
    # <tt>:returns</tt>::     Search according to the return type. Can be a string or symbol.
    #                         Only works on Functions and Methods
    #
    # All arguments added to the options are processed in an AND format. If you
    # are looking for 3 random arguments with a return type of int:
    #
    #   find(:arguments => [nil, nil, nil], :returns => :int)
    #
    # It's also possible to do this in two steps, chaining the +find+ calls, as long as 
    # each +find+ in the chain has multiple results:
    #
    #   find(:arguments => [nil, nil, nil]).find(:returns => :int)
    # 
    # However if you want 3 random arguments OR returning int, you should use 
    # two seperate queries:
    #
    #   find(:arguments => [nil, nil, nil])
    #   find(:returns => :int)
    #
    # When dealing with how to specify the types, Typedefs, user defined types, fundamental
    # types (int, char, etc) and pointers to all of these are currently supported. To find
    # functions that return a pointer to MyClass:
    #
    #   find(:returns => "MyClass*")
    #
    # Returns: A new QueryResult containing the results, allowing for nested +finds+. 
    # However, If there is only one result, returns that single Node instead.
    def find(options = {})
      result = QueryResult.new

      # Handler hash for doing AND intersection checking
      found = {}

      name = options.delete(:name)
      returns = options.delete(:returns)
      arguments = options.delete(:arguments)

      raise ":arguments must be an array" if arguments && !arguments.is_a?(Array)
      raise "Unknown keys #{option.keys.join(", ")}. " +
        "Expected are: :name, :arguments, and :returns" unless options.empty?

      self.each do |node|
        # C++ name
        if name
          found[:name] ||= []
          if name.is_a?(Regexp)
            found_name = (node.attributes["name"] =~ name)
          else
            found_name = (node.attributes["name"] == name)
          end

          found[:name] << node if found_name
        end

        # Return type
        if returns && [Function, Method].include?(node.class)
          found[:returns] ||= []
          found[:returns] << node if node.return_type == returns.to_s
        end

        # Arguments list
        if arguments && [Function, Method, Constructor].include?(node.class)
          found[:arguments] ||= []
          keep = false
          args = node.arguments

          if args.size == arguments.size
            keep = true
            arguments.each_with_index do |arg, idx|
              # nil is the "any" flag
              if !arg.nil? && args[idx].cpp_type != arg.to_s
                keep = false
                break
              end
            end
          end

          found[:arguments] << node if keep
        end
      end

      # Now we do an intersection of all the found nodes,
      # which ensures that we AND together all the parts
      # the user is looking for
      tmp = self
      found.each_value do |value|
        tmp = (tmp & value)
      end

      # But make sure that we always have a QueryResult and 
      # not a plain Array
      result << tmp
      result.flatten!

      result.length == 1 ? result[0] : result
    end
  end
end
