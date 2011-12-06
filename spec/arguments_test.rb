require "test_helper"

describe "Function and Method Arguments" do

  before(:all) do
    @arguments_source = RbGCCXML.parse(full_dir("headers/functions.h")).namespaces("functions")
  end

  specify "have type and to_cpp" do
    test1 = @arguments_source.functions("test1")
    test1.arguments.length.should == 2

    test1.arguments[0].to_cpp.should == "int x"
    test1.arguments[0].cpp_type.to_cpp.should == "int"

    test1.arguments[1].to_cpp.should == "double y"
    test1.arguments[1].cpp_type.to_cpp.should == "double"
  end

  specify "can have a default value" do
    test1 = @arguments_source.functions("test1")
    test1.arguments[0].value.should be_nil
    test1.arguments[1].value.should == "3.0e+0"

    rockin = @arguments_source.functions("rockin")
    rockin.arguments[1].value.should == "functions::test()"
  end

  specify "should be a QueryResult" do
    test = @arguments_source.functions("test1")
    test.arguments.should be_a_kind_of(RbGCCXML::QueryResult)
  end
end

