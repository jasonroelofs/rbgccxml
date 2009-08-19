require File.join(File.dirname(__FILE__), 'test_helper')

context "Querying for structs" do
  setup do
    @@structs_source ||= RbGCCXML.parse(full_dir("headers/structs.h")).namespaces("structs")
  end

  specify "can find all structs in a given namespace" do
    structs = @@structs_source.structs
    structs.size.should == 3 

    %w(Test1 Test2 Test3).each do |t|
      assert structs.detect {|c| c.node == @@structs_source.structs(t).node }, 
        "unable to find node for #{t}"
    end
  end

  specify "can find structs within structs" do
    test1 = @@structs_source.structs.find(:name => "Test1")
    test1.should.not.be.nil
    
    inner1 = test1.structs("Inner1")
    inner1.should.not.be.nil
    
    inner2 = inner1.structs("Inner1")
    inner2.should.not.be.nil
  end
end

context "Querying for struct constructors" do
  setup do
    @@structs_source ||= RbGCCXML.parse(full_dir("headers/structs.h")).namespaces("structs")
  end

  specify "should have a list of constructors" do
    test1 = @@structs_source.structs.find(:name => "Test1")
    test1.constructors.size.should == 2

    test2 = @@structs_source.structs.find(:name => "Test2")
    test2.constructors.size.should == 3
  end

  specify "constructors should have arguments" do
    test2 = @@structs_source.structs.find(:name => "Test2")

    # GCC generated copy constructors
    copy = test2.constructors[0]
    copy.attributes[:artificial].should == "1"

    default = test2.constructors[1]
    default.arguments.size.should == 0

    specific = test2.constructors[2]
    specific.arguments.size.should == 1
    assert(specific.arguments[0].cpp_type == "int")
  end
end

