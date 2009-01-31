
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

  specify "properly prints out fully qualified C++ identifier for enum values" do
    enum = @@enum_source.enumerations("TestEnum")
    enum.values.length.should == 3
    assert enum.values[0].qualified_name == "enums::VALUE1"
    assert enum.values[1].qualified_name == "enums::VALUE2"
    assert enum.values[2].qualified_name == "enums::VALUE3"

    enum = @@enum_source.classes("Inner").enumerations("InnerEnum")
    assert enum.values[0].qualified_name == "enums::Inner::INNER_1"
    assert enum.values[1].qualified_name == "enums::Inner::INNER_2"
  end

  specify "Can ind out what file an enum is in." do
    enum = @@enum_source.enumerations("TestEnum")
    assert_nothing_thrown { enum.file_name.should == "enums.h" }
    assert_nothing_thrown { enum.file_name(true).should == "enums.h" }
  end
end

