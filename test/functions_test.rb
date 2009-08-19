require File.join(File.dirname(__FILE__), 'test_helper')

context "Querying for functions" do

  setup do
    @@functions_source ||= RbGCCXML.parse(full_dir("headers/functions.h")).namespaces("functions")
  end

  specify "should be able to find all functions" do
    @@functions_source.functions.length.should == 2
  end

  specify "can find functions by name" do
    # Short-hand finding does #find(:name => "")
    test1 = @@functions_source.functions("test1")
    test1.should.be.a.kind_of RbGCCXML::Function
    test1.name.should == "test1"

    bool = @@functions_source.functions.find(:name => "bool_method")
    bool.should.be.a.kind_of RbGCCXML::Function
    bool.name.should == "bool_method"
  end

  specify "should not have a classes finder" do
    test1 = @@functions_source.functions("test1")
    should.raise RbGCCXML::NotQueryableException do
      test1.classes  
    end
  end

  specify "should not have a namespaces finder" do
    test1 = @@functions_source.functions("test1")
    should.raise RbGCCXML::NotQueryableException do
      test1.namespaces
    end
  end

  specify "should not have a functions finder" do
    test1 = @@functions_source.functions("test1")
    should.raise RbGCCXML::NotQueryableException do
      test1.functions  
    end
  end
end
