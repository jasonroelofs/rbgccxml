require "test_helper"

context "Function and Method Arguments" do

  setup do
    @@arguments_source ||= RbGCCXML.parse(full_dir("headers/functions.h")).namespaces("functions")
  end

  specify "have type and to_cpp" do
    test1 = @@arguments_source.functions("test1")
    test1.arguments.length.should.equal 2

    test1.arguments[0].to_cpp.should.equal "int x"
    test1.arguments[0].cpp_type.to_cpp.should.equal "int"

    test1.arguments[1].to_cpp.should.equal "double y"
    test1.arguments[1].cpp_type.to_cpp.should.equal "double"
  end

  specify "can have a default value" do
    test1 = @@arguments_source.functions("test1")
    test1.arguments[0].value.should.be nil
    test1.arguments[1].value.should.equal "3.0e+0"

    rockin = @@arguments_source.functions("rockin")
    rockin.arguments[1].value.should.equal "functions::test()"
  end
end

