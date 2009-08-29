require File.join(File.dirname(__FILE__), 'test_helper')

context "Proper Type handling" do

  setup do
    @@types_source ||= RbGCCXML.parse(full_dir("headers/types.h")).namespaces("types")
  end

  specify "fundamental types" do
    assert @@types_source.functions.find(:returns => "int") == "returnsInt"
    assert @@types_source.functions.find(:returns => "float") == "returnsFloat"
  end

  xspecify "unsigned fundamental types" do
  end

  specify "typedefs" do
    assert @@types_source.functions.find(:returns => "myLongType") == "returnsLongType"
    assert @@types_source.functions.find(:returns => "myShortType") == "returnsShortType"
  end

  specify "user defined types (classes / structs)" do
    assert @@types_source.functions.find(:returns => "user_type") == "returnsUserType"
    assert @@types_source.functions.find(:returns => "struct_type") == "returnsStructType"
  end

  # Are these three necessary or can it be just one?
  specify "pointers to user defined types" do
    assert @@types_source.functions.find(:returns => "user_type*") == "returnsUserTypePointer"
    assert @@types_source.functions.find(:returns => "struct_type*") == "returnsStructTypePointer"
  end

  specify "pointers to fundamental types" do
    assert @@types_source.functions.find(:returns => "int*") == "returnsIntPointer"
  end

  specify "pointers to typedefs" do
    assert @@types_source.functions.find(:returns => "myLongType*") == "returnsLongTypePointer"
  end

  specify "reference types" do
    assert @@types_source.functions.find(:returns => "struct_type&") == "returnStructReference"
  end

  specify "const definitions (fundamental types)" do
    assert @@types_source.functions.find(:returns => "const int") == "returnConstInt"
  end

  specify "const definitions (defined types)" do
    assert @@types_source.functions.find(:returns => "const struct_type") == "returnConstStruct"
  end

  specify "const references" do
    assert @@types_source.functions.find(:returns => "const user_type&") == "returnConstUserTypeRef"
  end

  specify "const pointers" do
    assert @@types_source.functions.find(:returns => "const int*") == "returnConstIntPointer"
  end

  specify "enumerations" do
    assert @@types_source.functions.find(:returns => "myEnum") == "returnMyEnum"
  end

  specify "arrays" do
    assert @@types_source.functions.find(:arguments => ["int[4]*"]) == "usesIntArray"
  end

  specify "function pointers" do
    assert @@types_source.functions.find(:arguments => ["Callback"]) == "takesCallback"
    assert @@types_source.functions.find(:arguments => ["CallbackWithReturn"]) == "takesCallbackWithReturn"
  end

end

context "Printing types" do
  
  setup do
    @@types_source ||= RbGCCXML.parse(full_dir("headers/types.h")).namespaces("types")
  end

  specify "types should print back properly into string format" do
    @@types_source.functions.find(:returns => "int").return_type.name.should == "int"
    @@types_source.functions.find(:returns => "int").return_type.to_cpp.should == "int"

    @@types_source.functions.find(:returns => "float").return_type.name.should == "float"

    # pointers
    @@types_source.functions.find(:returns => "int*").return_type.to_cpp.should == "int*"

    # references
    @@types_source.functions.find(:returns => "struct_type&").return_type.to_cpp.should == "types::struct_type&"
    
    # printout full from the global namespace
    @@types_source.functions.find(:returns => "string").return_type.to_cpp.should == "others::string"

    # const
    @@types_source.functions.find(:returns => "const int").return_type.to_cpp.should == "const int"
    
    # const pointers
    @@types_source.functions.find(:returns => "const int*").return_type.to_cpp.should == "const int*"

    # const references
    @@types_source.functions.find(:returns => "const user_type&").return_type.to_cpp.should == "const types::user_type&"

    # Enumerations
    @@types_source.functions.find(:returns => "myEnum").return_type.name.should == "myEnum"
    @@types_source.functions.find(:returns => "myEnum").return_type.to_cpp.should == "types::myEnum"

    # Array Types
    @@types_source.functions.find(:name => "usesIntArray").arguments[0].name.should == "input"
    @@types_source.functions.find(:name => "usesIntArray").arguments[0].to_cpp.should == "int[4]* input"
  end

  specify "can get to the base C++ construct of given types" do
    @@types_source.functions.find(:returns => "const user_type&").return_type.base_type.name.should == "user_type"
    @@types_source.functions.find(:returns => "const int*").return_type.base_type.name.should == "int"
  end

  specify "can get types of class ivars" do
    @@types_source.classes("user_type").variables("var1").cpp_type.name.should == "int"
    @@types_source.classes("user_type").variables("var2").cpp_type.name.should == "float"

    @@types_source.structs("struct_type").variables("myType").cpp_type.to_cpp.should == "types::user_type"
  end

end

context "Type comparitors" do
  specify "can tell of a given type is a const" do
    assert @@types_source.functions.find(:returns => "const user_type&").return_type.const?
    assert @@types_source.functions.find(:returns => "const int*").return_type.const?
    assert !@@types_source.functions.find(:returns => "user_type").return_type.const?

    assert !@@types_source.functions.find(:returns => "string").return_type.const?
    assert !@@types_source.functions.find(:returns => "int").return_type.const?
  end
end
