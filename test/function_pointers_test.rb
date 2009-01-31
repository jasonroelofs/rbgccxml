require File.dirname(__FILE__) + '/test_helper'

context "Function pointers" do
  setup do
    @@fp_source ||= RbGCCXML.parse(full_dir("headers/types.h")).namespaces("types")
  end

  specify "have arguments" do
    fp = @@fp_source.functions("takesCallback").arguments[0].cpp_type.base_type
    fp.arguments.length.should == 1
    assert fp.arguments[0].cpp_type == "int"
  end

  specify "have return value" do
    fp = @@fp_source.functions("takesCallbackWithReturn").arguments[0].cpp_type.base_type
    assert fp.return_type == "int"
  end

  specify "can find out which file said function pointer is in" do
    fp = @@fp_source.functions("takesCallback")
    assert_nothing_thrown { fp.file_name.should == "types.h" }
    assert_nothing_thrown { fp.file_name(true).should == "types.h" }
  end
end
