require File.dirname(__FILE__) + '/test_helper'

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

end

context "Printing types" do
  
  setup do
    @@types_source ||= RbGCCXML.parse(full_dir("headers/types.h")).namespaces("types")
  end

  specify "types should print back properly into string format" do
    @@types_source.functions.find(:returns => "int").return_type.to_s.should == "int"
    @@types_source.functions.find(:returns => "float").return_type.to_s.should == "float"

    # pointers
    @@types_source.functions.find(:returns => "int*").return_type.to_s.should == "int*"

    # references
    @@types_source.functions.find(:returns => "struct_type&").return_type.to_s.should == "struct_type&"

    # const
    @@types_source.functions.find(:returns => "const int").return_type.to_s.should == "const int"
    
    # const pointers
    @@types_source.functions.find(:returns => "const int*").return_type.to_s.should == "const int*"

    # const references
    @@types_source.functions.find(:returns => "const user_type&").return_type.to_s.should == "const user_type&"
  end

end
