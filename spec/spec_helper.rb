require 'rspec/expectations'
require 'chefspec'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
