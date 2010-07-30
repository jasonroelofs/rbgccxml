module RbGCCXML

  # Singleton-ish class that keeps around references to the
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
            node.children = node["members"].split(" ").map do |child_id|
              @index_list[child_id]
            end
          end
        end
      end

    end
  end

end
