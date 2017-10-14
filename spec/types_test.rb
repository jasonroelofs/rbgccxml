require "test_helper"

describe "Proper Type handling" do

  before(:all) do
    @types_source = RbGCCXML.parse(full_dir("headers/types.hpp")).namespaces("types")
  end

  specify "fundamental types" do
    @types_source.functions.find(:returns => "int").length.should == 2
    @types_source.functions.find(:returns => "float").name.should == "returnsFloat"

    @types_source.functions("noReturnWithSizeT").arguments[0].to_cpp.should == "::std::size_t arg"
  end

  specify "typedefs" do
    @types_source.functions.find(:returns => "myLongType").name.should == "returnsLongType"
    @types_source.functions.find(:returns => "myShortType").name.should == "returnsShortType"
  end

  specify "user defined types (classes / structs)" do
    @types_source.functions.find(:returns => "user_type").name.should == "returnsUserType"
    @types_source.functions.find(:returns => "struct_type").length.should == 2
  end

  specify "pointers to user defined types" do
    @types_source.functions.find(:returns => "user_type*").name.should == "returnsUserTypePointer"
    @types_source.functions.find(:returns => "struct_type*").name.should == "returnsStructTypePointer"
  end

  specify "pointers to fundamental types" do
    @types_source.functions.find(:returns => "int*").length.should == 2
  end

  specify "pointers to typedefs" do
    @types_source.functions.find(:returns => "myLongType*").name.should == "returnsLongTypePointer"
  end

  specify "reference types" do
    @types_source.functions.find(:returns => "struct_type&").name.should == "returnStructReference"
  end

  specify "const definitions (fundamental types)" do
    @types_source.functions.find(:returns => "const int").name.should == "returnConstInt"
  end

  specify "const definitions (defined types)" do
    @types_source.functions.find(:returns => "const struct_type").name.should == "returnConstStruct"
  end

  specify "const references" do
    @types_source.functions.find(:returns => "const user_type&").name.should == "returnConstUserTypeRef"
  end

  specify "const pointers" do
    @types_source.functions.find(:returns => "const int*").name.should == "returnConstIntPointer"
  end

  specify "enumerations" do
    @types_source.functions.find(:returns => "myEnum").name.should == "returnMyEnum"
  end

  specify "arrays" do
    @types_source.functions.find(:arguments => ["int[4]*"]).name.should == "usesIntArray"
  end

  specify "function pointers" do
    @types_source.functions.find(:arguments => ["Callback"]).name.should == "takesCallback"
    @types_source.functions.find(:arguments => ["CallbackWithReturn"]).name.should == "takesCallbackWithReturn"
  end

end

describe "Printing types" do

  before(:all) do
    @types_source = RbGCCXML.parse(full_dir("headers/types.hpp")).namespaces("types")
  end

  specify "types should print back properly into string format" do
    @types_source.functions("returnsInt").return_type.name.should == "int"
    @types_source.functions("returnsInt").return_type.to_cpp.should == "int"

    @types_source.functions("returnsFloat").return_type.name.should == "float"

    # pointers
    @types_source.functions("returnsIntPointer").return_type.to_cpp.should == "int*"

    # references
    @types_source.functions("returnStructReference").return_type.to_cpp.should == "::types::struct_type&"
    @types_source.functions("returnStructReference").return_type.to_cpp(false).should == "struct_type&"

    # printout full from the global namespace
    @types_source.functions("returnsString").return_type.to_cpp.should == "::others::string"
    @types_source.functions("returnsString").return_type.to_cpp(false).should == "string"

    # const
    @types_source.functions("returnConstInt").return_type.to_cpp.should == "const int"

    # const pointers
    @types_source.functions("returnConstIntPointer").return_type.to_cpp.should == "const int*"

    # const references
    @types_source.functions("returnConstUserTypeRef").return_type.to_cpp.should == "const ::types::user_type&"
    @types_source.functions("returnConstUserTypeRef").return_type.to_cpp(false).should == "const user_type&"

    # const const
    @types_source.functions("withConstPtrConst").arguments[0].to_cpp.should == "const ::types::user_type* const arg1"
    @types_source.functions("withConstPtrConst").arguments[0].to_cpp(false).should == "const user_type* const arg1"

    # Enumerations
    @types_source.functions("returnMyEnum").return_type.name.should == "myEnum"
    @types_source.functions("returnMyEnum").return_type.to_cpp.should == "::types::myEnum"

    # Array Types
    @types_source.functions("usesIntArray").arguments[0].name.should == "input"
    @types_source.functions("usesIntArray").arguments[0].to_cpp.should == "int[4]* input"
  end

  specify "can get to the base C++ construct of given types" do
    @types_source.functions.find(:returns => "const user_type&").return_type.base_type.name.should == "user_type"
    @types_source.functions.find(:returns => "const int*").return_type.base_type.name.should == "int"
  end

  specify "can get types of class ivars" do
    @types_source.classes("user_type").variables("var1").cpp_type.name.should == "int"
    @types_source.classes("user_type").variables("var2").cpp_type.name.should == "float"

    @types_source.structs("struct_type").variables("myType").cpp_type.to_cpp.should == "::types::user_type"
  end

end

describe "Type comparitors" do
  specify "can tell of a given type is a const" do
    @types_source ||= RbGCCXML.parse(full_dir("headers/types.hpp")).namespaces("types")
    @types_source.functions("returnConstUserTypeRef").return_type.should be_const
    @types_source.functions("returnConstIntPointer").return_type.should be_const
    @types_source.functions("returnsUserType").return_type.should_not be_const

    @types_source.functions("returnsString").return_type.should_not be_const
    @types_source.functions("returnsInt").return_type.should_not be_const
  end
end
