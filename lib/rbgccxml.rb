require 'hpricot'
gem 'gccxml_gem'
require 'gccxml'

require 'rbgccxml/rbgccxml'

module RbGCCXML

  # Core classes
  autoload :Parser, "rbgccxml/parser"
  autoload :Node, "rbgccxml/node"
  autoload :QueryResult, "rbgccxml/query_result"
  autoload :XMLParsing, "rbgccxml/xml_parsing"

  # Nodes
  autoload :Argument, "rbgccxml/nodes/argument" 
  autoload :Class, "rbgccxml/nodes/class" 
  autoload :Constructor, "rbgccxml/nodes/constructor" 
  autoload :File, "rbgccxml/nodes/file" 
  autoload :Function, "rbgccxml/nodes/function" 
  autoload :Method, "rbgccxml/nodes/method" 
  autoload :Namespace, "rbgccxml/nodes/namespace" 
  autoload :Struct, "rbgccxml/nodes/struct" 

  # Type Management
  autoload :Type, "rbgccxml/nodes/type"
  autoload :FundamentalType, "rbgccxml/nodes/types/fundamental_type" 
  autoload :PointerType, "rbgccxml/nodes/types/pointer_type" 
  autoload :Typedef, "rbgccxml/nodes/types/typedef" 

end
