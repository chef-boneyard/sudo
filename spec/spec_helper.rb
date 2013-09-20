require 'berkshelf'
require 'chefspec'

Berkshelf.ui.mute do
  berksfile = Berkshelf::Berksfile.from_file('Berksfile')
  berksfile.install(path: 'vendor/cookbooks', only: 'integration')
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
