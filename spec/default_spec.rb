require 'spec_helper'

describe 'sudo::default' do
  before(:each) do
    stub_command('which sudo').and_return(false)
  end

  context 'usual business' do
    cached(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'creates the /etc/sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content(/Defaults      !lecture,tty_tickets,!fqdn/)
    end

    it 'creates the sudoers.d directory' do
      expect(chef_run).to create_directory('/etc/sudoers.d').with(
        owner: 'root',
        mode: '0755'
      )
    end
  end

  context "node['authorization']['sudo']['groups']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['authorization']['sudo']['groups'] = %w(bacon)
      end.converge(described_recipe)
    end

    it 'adds users of the bacon group to the sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('%bacon ALL=(ALL) ALL')
    end
  end

  context "node['authorization']['sudo']['passwordless']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['authorization']['sudo']['users'] = %w(bacon)
        node.override['authorization']['sudo']['groups'] = %w(bacon-group)
        node.override['authorization']['sudo']['passwordless'] = true
      end.converge(described_recipe)
    end

    it 'gives users and groups passwordless sudo' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('bacon ALL=(ALL) NOPASSWD:ALL')
      expect(chef_run).to render_file('/etc/sudoers').with_content('%bacon-group ALL=(ALL) NOPASSWD:ALL')
    end
  end

  context "node['authorization']['sudo']['agent_forwarding']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['authorization']['sudo']['agent_forwarding'] = true
      end.converge(described_recipe)
    end

    it 'includes ssh forwarding in the sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      env_keep+=SSH_AUTH_SOCK')
    end
  end

  context "node['authorization']['sudo']['sudoers_defaults']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['authorization']['sudo']['sudoers_defaults'] = %w(ham bacon)
      end.converge(described_recipe)
    end

    it 'includes each default' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      ham')
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      bacon')
    end
  end

  context 'config prefix' do
    context 'on macOS' do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.13').converge(described_recipe) }

      it 'uses /private/etc' do
        expect(chef_run).to create_template('/private/etc/sudoers')
      end
    end

    context 'on SmartOS' do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'smartos', version: '5.11').converge(described_recipe) }

      it 'uses /opt/local/etc' do
        expect(chef_run).to create_template('/opt/local/etc/sudoers')
      end
    end

    context 'on Ubuntu' do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

      it 'uses /etc' do
        expect(chef_run).to create_template('/etc/sudoers')
      end
    end
  end

  context "node['authorization']['sudo']['command_aliases']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['authorization']['sudo']['command_aliases'] =
          [{ name: 'TESTA', command_list: ['/usr/bin/whoami'] }, { name: 'TeSTb', command_list: ['/usr/bin/ruby', '! /usr/bin/perl'] }]
      end.converge(described_recipe)
    end

    it 'includes each command alias making sure they are upcased' do
      expect(chef_run).to render_file('/etc/sudoers').with_content(
        'Cmnd_Alias TESTA = /usr/bin/whoami'
      )
      expect(chef_run).to render_file('/etc/sudoers').with_content(
        'Cmnd_Alias TESTB = /usr/bin/ruby, ! /usr/bin/perl'
      )
    end
  end

  context "node['authorization']['sudo']['custom_commands']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['authorization']['sudo']['command_aliases'] =
          [{ name: 'TESTA', command_list: ['/usr/bin/whoami'] }, { name: 'TeSTb', command_list: ['/usr/bin/ruby', '! /usr/bin/perl'] }]
        node.override['authorization']['sudo']['custom_commands']['users'] =
          [{ user: 'test_usera', passwordless: true, command_list: ['TESTA'] }, { user: 'test_userb', passwordless: false, command_list: ['TESTB'] }]
      end.converge(described_recipe)
    end

    it 'includes each command alias making sure they are upcased' do
      expect(chef_run).to render_file('/etc/sudoers').with_content(
        'test_usera ALL = NOPASSWD: TESTA'
      )
      expect(chef_run).to render_file('/etc/sudoers').with_content(
        'test_userb ALL =  TESTB'
      )
    end
  end

  context "node['authorization']['sudo']['env_keep_add']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['authorization']['sudo']['env_keep_add'] = ['TEST_ENV_ADD']
      end.converge(described_recipe)
    end
    it 'adds environment variables to /etc/sudoers' do
      expect(chef_run).to render_file('/etc/sudoers').with_content(
        'Defaults    env_keep += "TEST_ENV_ADD"'
      )
    end
  end

  context "node['authorization']['sudo']['env_keep_subtract']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['authorization']['sudo']['env_keep_subtract'] = ['TEST_ENV_SUB']
      end.converge(described_recipe)
    end
    it 'adds environment variables to /etc/sudoers' do
      expect(chef_run).to render_file('/etc/sudoers').with_content(
        'Defaults    env_keep -= "TEST_ENV_SUB"'
      )
    end
  end

  context 'Non-Linux distro' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'freebsd', version: '11.0').converge(described_recipe)
    end

    it 'does not create the sudoers.d directory' do
      expect(chef_run).not_to create_directory('/etc/sudoers.d')
    end
  end
end
