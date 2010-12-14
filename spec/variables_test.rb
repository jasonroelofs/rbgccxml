require "test_helper"

describe "Querying for variables" do

  before(:all) do
    @variables_source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "find global variables and constants" do
    @variables_source.variables.length.should == 2
  end

  specify "find class variables" do
    test1 = @variables_source.classes("Test1")
    test1.variables.length.should == 4
    test1.variables.find(:access => :public).length.should == 2
    test1.variables("publicVariable").should_not be_nil
    test1.variables("publicVariable2").should_not be_nil
  end

  specify "can also find constants" do
    test1 = @variables_source.classes("Test1")
    test1.constants.length.should == 1
    test1.constants("CONST").should_not be_nil
  end
end
