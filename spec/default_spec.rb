require 'spec_helper'

describe 'sudo::default' do
  context 'usual business' do
    let(:runner) do
      ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').converge 'sudo::default'
    end

    it 'installs the sudo package' do
      runner.should install_package 'sudo'
    end

    it 'creates the /etc/sudoers file' do
      runner.should create_file_with_content '/etc/sudoers', 'Defaults      !lecture,tty_tickets,!fqdn'
    end
  end

  context 'with custom prefix' do
    let(:runner) do
      ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['authorization'] = {
          'sudo' => {
            'prefix' => '/secret/etc'
          }
        }
      end.converge 'sudo::default'
    end

    it 'creates the sudoers file in the custom location' do
      runner.should create_file_with_content '/secret/etc/sudoers', 'Defaults      !lecture,tty_tickets,!fqdn'
    end
  end

  context 'sudoers.d' do
    let(:runner) do
      ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['authorization'] = {
          'sudo' => {
            'include_sudoers_d' => 'true'
          }
        }
      end.converge 'sudo::default'
    end

    it 'creates the sudoers.d directory' do
      runner.should create_directory '/etc/sudoers.d'
      runner.directory('/etc/sudoers.d').should be_owned_by 'root', 'root'
    end

    it 'drops the README file' do
      runner.should create_file_with_content '/etc/sudoers.d/README', 'As of Debian version 1.7.2p1-1, the default /etc/sudoers file created on'
    end
  end
end
