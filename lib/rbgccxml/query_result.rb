module RbGCCXML
  # All queries return either an instance of this class, or in the case of
  # a single result, the node found. Use this class to further define query
  # parameters for multiple return sets.
  class QueryResult < Array

    # To facilitate the management of what could be many nodes found by a single query,
    # we forward off any unknown methods to each node in the results query.
    # We assume that if one node accepts the method, then all of them will.
    def method_missing(name, *args)
      if self[0].respond_to?(name)
        self.inject(QueryResult.new) do |memo, node|
          ret = node.send(name, *args)
          memo << ret if ret
          memo
        end
      else
        super
      end
    end

    EXPECTED_OPTIONS = [:name, :returns, :arguments, :access] unless defined?(EXPECTED_OPTIONS)

    # Find within this result set any nodes that match the given options.
    # Options can be any or all of the following, based on the type of node
    # (all entries can be either Strings or Symbols):
    #
    # <tt>:name</tt>::        The unmangled name of the node. Can be a string or Regexp. Works on all nodes.
    # <tt>:arguments</tt>::   Search according to argument types.
    #                         This needs to be an array of strings or symbols. nil is used as the wildcard.
    #                         Only works on Functions, Methods, and Constructors
    # <tt>:returns</tt>::     Search according to the return type. Can be a string or symbol.
    #                         Only works on Functions and Methods
    # <tt>:access</tt>::      Search according to access properties. Can be :public, :protected, or :private.
    #                         Only works on Classes and Methods
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
    # Typedefs, user defined types, fundamental types (int, char, etc), pointers, and references
    # are all supported. For example, to find functions that return a pointer to MyClass:
    #
    #   find(:returns => "MyClass*")
    #
    # There will be cases where you'll want to search *all* of a given type no matter what the current scope
    # or nesting. To put a finder into this mode, specify :all as the first parameter:
    #
    #   find(:all, [arguments as defined above])
    #
    # This will find all nodes that fit the normal arguments for a given type (the node type of the first
    # in the initial result set. e.g. if you run <tt>classes.find(:all)</tt> then all Class nodes) across
    # the entire source.
    #
    # Returns: A new QueryResult containing the results, allowing for nested +finds+.
    # However, If there is only one result, returns that single Node instead.
    def find(*options)
      result = QueryResult.new
      query_set = self

      if options[0] == :all
        node_type = self[0].class.to_s.split(/::/)[-1]
        query_set = NodeCache.all(node_type)
        options = options[1]
      else
        options = options[0]
      end

      name = options.delete(:name)
      returns = options.delete(:returns)
      arguments = options.delete(:arguments)
      access = options.delete(:access)

      raise ":arguments must be an array" if arguments && !arguments.is_a?(Array)
      raise "Unknown keys #{options.keys.join(", ")}. " +
        "Expected are: #{EXPECTED_OPTIONS.join(",")}" unless options.empty?

      found = {}

      query_set.each do |node|
        # C++ name
        if name
          found[:name] ||= []
          found[:name] << node if matches?(node.name, name)
        end

        # Return type
        if returns && [Function, Method].include?(node.class)
          found[:returns] ||= []
          found[:returns] << node if type_matches?(node.return_type, returns.to_s)
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
              if !arg.nil? && !type_matches?(args[idx].cpp_type, arg.to_s)
                keep = false
                break
              end
            end
          end

          found[:arguments] << node if keep
        end

        # Access type
        if access
          found[:access] ||= []
          found[:access] << node if node["access"] == access.to_s
        end
      end

      # Now we do an intersection of all the found nodes,
      # which ensures that we AND together all the parts
      # the user is looking for
      tmp = query_set
      found.each_value do |value|
        tmp = (tmp & value)
      end

      # But make sure that we always have a QueryResult and
      # not a plain Array
      result << tmp
      result.flatten!

      result.length == 1 ? result[0] : result
    end

    # Performs a normal Enumerable#find_all operation, except that if only
    # one Node is being returned by the Enumerable#find_all, returns that
    # single node.
    def find_all(&block)
      res = QueryResult.new(super)
      res.length == 1 ? res[0] : res
    end

    # Same with #find_all, force to work as a QueryResult
    def select(&block)
      res = QueryResult.new(super)
      res.length == 1 ? res[0] : res
    end

    private

    # Finders can take strings or regexes, so this wraps up the logic that chooses
    # between straight equality matching and matching
    def matches?(value, against)
      case against
      when Regexp
        value =~ against
      else
        value == against
      end
    end

    def type_matches?(node, against)
      against_full =
        against.is_a?(Regexp) ?
          against :
          /#{against.to_s.gsub("*", "\\*").gsub(/^::/, "").gsub("[", "\\[").gsub("]", "\\]")}$/

      matches?(node.name, against) ||
        matches?(node.to_cpp, against_full) ||
        matches?(node.to_cpp(false), against_full)
    end


  end
end
