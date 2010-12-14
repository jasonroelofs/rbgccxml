require "test_helper"

describe "Querying for structs" do
  before(:all) do
    @structs_source = RbGCCXML.parse(full_dir("headers/structs.h")).namespaces("structs")
  end

  specify "can find all structs in a given namespace" do
    structs = @structs_source.structs
    structs.size.should == 3 

    @structs_source.structs("Test1").should_not be_nil
    @structs_source.structs("Test2").should_not be_nil
    @structs_source.structs("Test3").should_not be_nil
  end

  specify "can find structs within structs" do
    test1 = @structs_source.structs.find(:name => "Test1")
    test1.should_not be_nil
    
    inner1 = test1.structs("Inner1")
    inner1.should_not be_nil
    
    inner2 = inner1.structs("Inner1")
    inner2.should_not be_nil
  end
end

describe "Querying for struct constructors" do
  before(:all) do
    @structs_source = RbGCCXML.parse(full_dir("headers/structs.h")).namespaces("structs")
  end

  specify "should have a list of constructors" do
    test1 = @structs_source.structs.find(:name => "Test1")
    test1.constructors.size.should == 2

    test2 = @structs_source.structs.find(:name => "Test2")
    test2.constructors.size.should == 3
  end

  specify "constructors should have arguments" do
    test2 = @structs_source.structs.find(:name => "Test2")

    # GCC generated copy constructors
    copy = test2.constructors[0]
    copy.artificial?.should be_true

    default = test2.constructors[1]
    default.arguments.size.should == 0

    specific = test2.constructors[2]
    specific.arguments.size.should == 1
    specific.arguments[0].cpp_type.name.should == "int"
  end
end

