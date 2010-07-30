module RbGCCXML

  # Manager of the tree of Nodes we build from GCC-XML.
  #
  # This is a static class that keeps around references to the
  # entire generated Node tree as well as other structures
  # designed for quick and easy searching of Nodes
  class NodeCache
    class << self

      # Hash of id => node for all nodes
      attr_accessor :index_list

      # Add a new node to the index list
      def <<(node)
        @index_list ||= {}
        @index_list[node.id] = node
      end

      # Get the root node of the parse
      def root
        # This is simply a way to hide GCC_XML specifics,
        # the :: Namespace node is always id _1
        @index_list["_1"]
      end

      # Look through the DOM under +node+ for +type+ nodes.
      # +type+ must be the string name of an existing Node subclass.
      #
      # Returns a QueryResult with the findings.
      def find_children_of_type(node, type, matcher)
        results = QueryResult.new(self.select_nodes_of_type(node.children, type))
        results = results.find(:name => matcher) if matcher
        results
      end

      # Once all parsing is done and all nodes are in memory
      # we need to actually build up the parent / child relationships
      # of the nodes. We can't do this during parsing because there
      # is no guarentee the nodes will come in the right order
      def process_tree
        @index_list.each do |id, node|
          # Build our parent, if there is one
          node.parent = @index_list[node["context"]] if node["context"]

          # Build our children if there are some
          if node["members"] && node["members"].any?
            # Structure we're working with here is: members="_1 _2 _4 _8 _12"
            node.children = node["members"].split(" ").map do |child_id|
              @index_list[child_id]
            end
          end
        end
      end

      protected

      def select_nodes_of_type(nodes, type)
        nodes.select {|node| node.class.to_s == "RbGCCXML::#{type}" }
      end

    end
  end

end
