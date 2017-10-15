require "test_helper"

describe "Querying for structs" do
  before(:all) do
    @structs_source = RbGCCXML.parse(full_dir("headers/structs.hpp")).namespaces("structs")
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
    @structs_source = RbGCCXML.parse(full_dir("headers/structs.hpp")).namespaces("structs")
  end

  specify "should have a list of constructors" do
    test1 = @structs_source.structs.find(:name => "Test1")
    test1.constructors.size.should == 2

    test2 = @structs_source.structs.find(:name => "Test2")
    test2.constructors.size.should == 3
  end

  specify "constructors should have arguments" do
    test2 = @structs_source.structs.find(:name => "Test2")

    # GCC generated copy constructor
    copy = test2.constructors.detect {|c| c.arguments.length == 1 && c.artificial? }
    copy.should_not be_nil

    default = test2.constructors.detect {|c| c.arguments.size == 0 }
    default.should_not be_nil

    specific = test2.constructors.detect {|c| c.arguments.size == 1 && !c.artificial? }
    specific.arguments[0].cpp_type.name.should == "int"
  end
end

