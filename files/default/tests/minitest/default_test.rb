require File.expand_path '../support/helpers', __FILE__

describe 'sudo::default' do
  include Helpers::Sudo

  it 'installs sudo' do
    package('sudo').must_be_installed
  end
end
