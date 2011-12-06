require "test_helper"

describe "Querying for enumerations" do
  before(:all) do
    @enum_source = RbGCCXML.parse(full_dir("headers/enums.h")).namespaces("enums")
  end

  specify "can query for enumerations" do
    enums = @enum_source.enumerations
    enums.length.should == 3
  end

  specify "can find specific enum values" do
    enum = @enum_source.enumerations("TestEnum")
    enum.values.length.should == 3
    enum.values[0].name.should == "VALUE1"
    enum.values[1].name.should == "VALUE2"
    enum.values[2].name.should == "VALUE3"
  end

  specify "can find the given value of enum entries" do
    enum = @enum_source.enumerations.find(:name => "MyEnum")
    enum.values[0].value.should == 3
    enum.values[1].value.should == 4
    enum.values[2].value.should == 7
  end

  specify "properly prints out fully qualified C++ identifier for enum values" do
    enum = @enum_source.enumerations("TestEnum")
    enum.values.length.should == 3
    enum.values[0].qualified_name.should == "enums::VALUE1"
    enum.values[1].qualified_name.should == "enums::VALUE2"
    enum.values[2].qualified_name.should == "enums::VALUE3"

    enum = @enum_source.classes("Inner").enumerations("InnerEnum")
    enum.values[0].qualified_name.should == "enums::Inner::INNER_1"
    enum.values[1].qualified_name.should == "enums::Inner::INNER_2"
  end

  specify "knows if an enumeration is anonymous" do
    found = @enum_source.enumerations.select {|e| e.anonymous? }

    found.should be_a(RbGCCXML::Enumeration)
    found.values[0].value.should == 0
    found.values[1].value.should == 1
    found.values[2].value.should == 2
  end

  specify "should be a QueryResult" do
    enum = @enum_source.enumerations("TestEnum")
    enum.values.length.should == 3
    enum.values.should be_a_kind_of(RbGCCXML::QueryResult)
  end
end

