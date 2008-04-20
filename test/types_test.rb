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

end
