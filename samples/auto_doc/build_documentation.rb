#!/usr/bin/env ruby

require 'rubygems'
require 'rbgccxml'

# Script that looks through headers and builds a basic 
# doxygen documentation about class methods

source = RbGCCXML.parse(
  File.expand_path(
    File.dirname(__FILE__) + "/headers/logger.h")).
    namespaces("logger")

logger = source.classes("Logger")
logger.methods.each do |method|
  puts "/* #{method.name} "
  puts " *"
  method.arguments.each do |arg|
    puts " * \\param #{arg.name} (#{arg.cpp_type.name})"
  end

  puts " * \\returns #{method.return_type.name}"
  puts "*/"
  puts ""
end
