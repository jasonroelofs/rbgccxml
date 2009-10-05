require "test_helper"

context "Querying for enumerations" do
  setup do
    @@enum_source ||= RbGCCXML.parse(full_dir("headers/enums.h")).namespaces("enums")
  end

  specify "can query for enumerations" do
    enums = @@enum_source.enumerations
    enums.length.should.equal 3
  end

  specify "can find specific enum values" do
    enum = @@enum_source.enumerations("TestEnum")
    enum.values.length.should.equal 3
    enum.values[0].name.should.equal "VALUE1"
    enum.values[1].name.should.equal "VALUE2"
    enum.values[2].name.should.equal "VALUE3"
  end

  specify "can find the given value of enum entries" do
    enum = @@enum_source.enumerations.find(:name => "MyEnum")
    enum.values[0].value.should.equal 3
    enum.values[1].value.should.equal 4
    enum.values[2].value.should.equal 7
  end

  specify "properly prints out fully qualified C++ identifier for enum values" do
    enum = @@enum_source.enumerations("TestEnum")
    enum.values.length.should.equal 3
    enum.values[0].qualified_name.should.equal "enums::VALUE1"
    enum.values[1].qualified_name.should.equal "enums::VALUE2"
    enum.values[2].qualified_name.should.equal "enums::VALUE3"

    enum = @@enum_source.classes("Inner").enumerations("InnerEnum")
    enum.values[0].qualified_name.should.equal "enums::Inner::INNER_1"
    enum.values[1].qualified_name.should.equal "enums::Inner::INNER_2"
  end

  specify "knows if an enumeration is anonymous" do
    found = @@enum_source.enumerations.select {|e| e.anonymous? }
    found.length.should.equal 1
    found = found[0]

    assert found.is_a?(RbGCCXML::Enumeration)
    found.values[0].value.should.equal 0
    found.values[1].value.should.equal 1
    found.values[2].value.should.equal 2
  end

end

