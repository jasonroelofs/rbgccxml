module RbGCCXML

  # Manager of the tree of Nodes we build from GCC-XML.
  #
  # This is a static class that keeps around references to the
  # entire generated Node tree as well as other structures
  # designed for quick and easy searching of Nodes
  class NodeCache
    class << self

      # Hash of id => node for all nodes
      attr_reader :index_list

      # Hash of Type => [node list] for easy
      # searching of all nodes of a given type
      attr_reader :types_list

      # Add a new node to the index list
      def <<(node)
        @index_list ||= {}
        @types_list ||= {}

        @index_list[node.id] = node

        class_name = node.class.name.split("::")[-1]
        @types_list[class_name] ||= []
        @types_list[class_name] << node
      end

      def clear
        @index_list = {}
        @types_list = {}
      end

      # Get the root node of the parse
      def root
        # This is simply a way to hide GCC_XML specifics,
        # the :: Namespace node is always id _1
        @index_list["_1"]
      end

      # Given an id, find the node
      def find(id)
        @index_list[id]
      end

      # Get the list of all nodes of a given type
      def all(type)
        @types_list[type] || []
      end

      # Given an array of ids return an array of nodes that match
      def find_by_ids(ids)
        QueryResult.new(ids.map {|id| @index_list[id] })
      end

      # Look through the DOM under +node+ for +type+ nodes.
      # +type+ must be the string name of an existing Node subclass.
      #
      # Returns a QueryResult with the findings.
      def find_children_of_type(node, type, matcher = nil)
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

          # If this node has a context, link to that context as a parent
          # and then put ourselves as that parent's child
          if node["context"]
            node.parent = @index_list[node["context"]]
            node.parent.children << node
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
