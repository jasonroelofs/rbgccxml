
require File.dirname(__FILE__) + '/test_helper'

context "Querying for enumerations" do
  setup do
    @@enum_source ||= RbGCCXML.parse(full_dir("headers/enums.h")).namespaces("enums")
  end

  specify "can query for enumerations" do
    enums = @@enum_source.enumerations
    enums.length.should == 2

    assert @@enum_source.enumerations("TestEnum") == "TestEnum"
    assert @@enum_source.enumerations.find(:name => "MyEnum") == "MyEnum"
  end

  specify "can find specific enum values" do
    enum = @@enum_source.enumerations("TestEnum")
    enum.values.length.should == 3
    assert enum.values[0] == "VALUE1"
    assert enum.values[1] == "VALUE2"
    assert enum.values[2] == "VALUE3"
  end

  specify "can find the given value of enum entries" do
    enum = @@enum_source.enumerations.find(:name => "MyEnum")
    enum.values[0].value.should == 3
    enum.values[1].value.should == 4
    enum.values[2].value.should == 7
  end
end

