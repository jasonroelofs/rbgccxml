require "test_helper"

describe "Querying for functions" do

  before(:all) do
    @functions_source = RbGCCXML.parse(full_dir("headers/functions.h")).namespaces("functions")
  end

  specify "should be able to find all functions" do
    @functions_source.functions.length.should == 4
  end

  specify "can find functions by name" do
    # Short-hand finding does #find(:name => "")
    test1 = @functions_source.functions("test1")
    test1.should be_a_kind_of(RbGCCXML::Function)
    test1.name.should == "test1"

    bool = @functions_source.functions.find(:name => "bool_method")
    bool.should be_a_kind_of(RbGCCXML::Function)
    bool.name.should == "bool_method"
  end

  specify "should not have a classes finder" do
    test1 = @functions_source.functions("test1")
    lambda do
      test1.classes  
    end.should raise_error(RbGCCXML::NotQueryableException)
  end

  specify "should not have a namespaces finder" do
    test1 = @functions_source.functions("test1")
    lambda do
      test1.namespaces
    end.should raise_error(RbGCCXML::NotQueryableException)
  end

  specify "should not have a functions finder" do
    test1 = @functions_source.functions("test1")
    lambda do
      test1.functions
    end.should raise_error(RbGCCXML::NotQueryableException)
  end

  specify "can get list of arguments" do
    test1 = @functions_source.functions("test1")
    test1.arguments.length.should == 2
  end
end
