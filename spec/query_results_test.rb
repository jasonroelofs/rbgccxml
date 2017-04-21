require "test_helper"

describe "Managing Query results" do

  class MyObj
    attr_accessor :call_me_called, :other_thingy_called

    def call_me
      @call_me_called = true
    end

    def other_thingy
      @other_thingy_called = true
    end
  end

  specify "should forward off unknown methods to the results" do
    obj1 = MyObj.new
    obj2 = MyObj.new

    q = RbGCCXML::QueryResult.new
    q << obj1 << obj2

    q.call_me
    q.other_thingy

    obj1.call_me_called.should_not be_nil
    obj1.other_thingy_called.should_not be_nil

    obj2.call_me_called.should_not be_nil
    obj2.other_thingy_called.should_not be_nil

    lambda do
      q.not_here
    end.should raise_error(NoMethodError)
  end

  specify "should throw appropriately with an empty result set" do
    lambda do
      RbGCCXML::QueryResult.new.some_method
    end.should raise_error(NoMethodError)
  end

  specify "should error out with unknown keys" do
    lambda do
      RbGCCXML::QueryResult.new.find(:key_bad => :hi_mom)
    end.should raise_error
  end

end

describe "QueryResult#find :name" do

  before(:all) do
    @query_source = RbGCCXML.parse(full_dir("headers/queryable.hpp")).namespaces("query")
  end

  specify "can find by regular name" do
    func = @query_source.functions.find(:name => "test4")
    func.should be_a_kind_of(RbGCCXML::Function)
    func.name.should == "test4"
  end

  specify "can find names by regex" do
    bool = @query_source.functions.find(:name => /bool/)
    bool.should be_a_kind_of(RbGCCXML::Function)
    bool.name.should == "bool_method"
  end

end

describe "QueryResult#find :arguments" do

  before(:all) do
    @query_source = RbGCCXML.parse(full_dir("headers/queryable.hpp")).namespaces("query")
  end

  specify "no arguments" do
    funcs = @query_source.functions.find(:arguments => [])
    funcs.detect {|f| f.name == "test1" }.should_not be_nil
    funcs.detect {|f| f.name == "bool_method" }.should_not be_nil
  end

  specify "multiple arguments" do
    # If we find just one result, we get it back
    func = @query_source.functions.find(:arguments => [:int])
    func.should be_a_kind_of(RbGCCXML::Function)
    func.name.should == "test2"

    func = @query_source.functions.find(:arguments => [:int, :float])
    func.should be_a_kind_of(RbGCCXML::Function)
    func.name.should == "test3"
  end

  specify "when searching arguments, can xspecify catch-all" do
    funcs = @query_source.functions.find(:arguments => [:int, nil])
    funcs.size.should == 2
    funcs.detect {|f| f.name == "test3" }.should_not be_nil
    funcs.detect {|f| f.name == "test4" }.should_not be_nil
  end

  specify "works when using custom defined types" do
    func = @query_source.functions.find(:arguments => ["MyType"])
    func.name.should == "testMyTypeArgs"
  end

  specify "works with pointers and references" do
    func = @query_source.functions.find(:arguments => ["MyType*"])
    func.length.should == 2

    func = @query_source.functions.find(:arguments => ["MyType&"])
    func.name.should == "testMyTypeArgsRef"
  end

  specify "works with qualified names" do
    func = @query_source.functions.find(:arguments => ["query::MyType"])
    func.name.should == "testMyTypeArgs"

    func = @query_source.functions.find(:arguments => ["::query::MyType"])
    func.name.should == "testMyTypeArgs"
  end

  specify "works with qualifiers like const" do
    func = @query_source.functions.find(:arguments => ["const MyType* const"])
    func.name.should == "testConstMyTypeArgsConstPtr"

    func = @query_source.functions.find(:arguments => ["MyType* const"])
    func.name.should == "testConstMyTypeArgsConstPtr"

    func = @query_source.functions.find(:arguments => ["const MyType*"])
    func.name.should == "testMyTypeArgsConstPtr"
  end
end

describe "QueryResult#find :returns" do

  before(:all) do
    @query_source = RbGCCXML.parse(full_dir("headers/queryable.hpp")).namespaces("query")
  end

  specify "by return type" do
    funcs = @query_source.functions.find(:returns => :void)
    funcs.detect {|f| f.name == "test1" }.should_not be_nil
    funcs.detect {|f| f.name == "test2" }.should_not be_nil
    funcs.detect {|f| f.name == "test3" }.should_not be_nil
  end

  specify "works with custom defined types" do
    func = @query_source.functions.find(:returns => "MyType")
    func.length.should == 2
  end

  specify "work with qualified names" do
    func = @query_source.functions.find(:returns => "query::MyType")
    func.length.should == 2

    func = @query_source.functions.find(:returns => "::query::MyType")
    func.length.should == 2
  end

  specify "works with pointers and references" do
    func = @query_source.functions.find(:returns => "MyType*")
    func.name.should == "testMyTypePtr"

    func = @query_source.functions.find(:returns => "MyType&")
    func.name.should == "testMyTypeRef"
  end

  specify "works with type modifiers (const)" do
    func = @query_source.functions.find(:returns => "const MyType")
    func.name.should == "testMyTypeConst"
  end
end

describe "QueryResult#find access type" do

  specify "can find according to public / private / protected" do
    @query_source = RbGCCXML.parse(full_dir("headers/queryable.hpp")).namespaces("query")
    klass = @query_source.classes("AccessTester")
    m = klass.methods.find(:access => :public)
    m.name.should == "publicMethod"

    m = klass.methods.find(:access => :protected)
    m.name.should == "protectedMethod"

    m = klass.methods.find(:access => :private)
    m.name.should == "privateMethod"
  end

end

describe "QueryResult#find multiple options" do

  specify "by both return type and arguments (AND form, not OR)" do
    @query_source = RbGCCXML.parse(full_dir("headers/queryable.hpp")).namespaces("query")
    func = @query_source.functions.find(:returns => :int, :arguments => [nil, nil])
    func.should be_a_kind_of(RbGCCXML::Function)
    func.name.should == "test4"
  end

end

describe "QueryResult#find :all - Flag full source search" do

  before(:all) do
    @query_source = RbGCCXML.parse(full_dir("headers/queryable.hpp")).namespaces("query")
  end

  specify "can find all :names regardless of nesting" do
    func = @query_source.functions.find(:all, :name => "nestedFunction")
    func.name.should == "nestedFunction"
  end

  specify "can find according to :arguments" do
    func = @query_source.functions.find(:all, :arguments => ["MyType", "MyType"])
    func.name.should == "nestedMyTypeArg"
  end

  specify "can find according to :returns " do
    funcs = @query_source.functions.find(:all, :returns => "MyType")
    funcs.size.should == 3
    funcs.detect {|f| f.name == "nestedMyTypeReturns"}.should_not be_nil
    funcs.detect {|f| f.name == "testMyType"}.should_not be_nil
    funcs.detect {|f| f.name == "testMyTypeConst"}.should_not be_nil
  end

end
