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
  autoload :Destructor, "rbgccxml/nodes/destructor"
  autoload :File, "rbgccxml/nodes/file" 
  autoload :Function, "rbgccxml/nodes/function" 
  autoload :Method, "rbgccxml/nodes/method" 
  autoload :Namespace, "rbgccxml/nodes/namespace" 
  autoload :Field, "rbgccxml/nodes/field" 
  autoload :Variable, "rbgccxml/nodes/variable" 
  autoload :Struct, "rbgccxml/nodes/struct" 
  autoload :Enumeration, "rbgccxml/nodes/enumeration"  
  autoload :EnumValue, "rbgccxml/nodes/enum_value"  
  autoload :FunctionType, "rbgccxml/nodes/function_type"

  # Type Management
  autoload :Type, "rbgccxml/nodes/type"
  autoload :FundamentalType, "rbgccxml/nodes/types/fundamental_type" 
  autoload :PointerType, "rbgccxml/nodes/types/pointer_type" 
  autoload :Typedef, "rbgccxml/nodes/types/typedef" 
  autoload :ReferenceType, "rbgccxml/nodes/types/reference_type"
  autoload :CvQualifiedType, "rbgccxml/nodes/types/cv_qualified_type"  
  autoload :ArrayType, "rbgccxml/nodes/types/array_type"

end
