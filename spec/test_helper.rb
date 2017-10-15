require 'rubygems'
require 'rspec'
require 'rbgccxml'
require 'pry'

module FileDirectoryHelpers
  def full_dir(path)
    File.expand_path(File.join(File.dirname(__FILE__), path))
  end
end

RSpec.configure do |config|
  config.include(FileDirectoryHelpers)
  config.expect_with(:rspec) { |c| c.syntax = :should }
end

# Don't complain about blank `raise_error` usage right now
RSpec::Expectations.configuration.on_potential_false_positives = :nothing
