require 'spec_helper'

describe 'sudo::default' do
  before(:each) do
    stub_command('which sudo').and_return(false)
  end

  context 'usual business' do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'installs the sudo package' do
      expect(chef_run).to install_package('sudo')
    end

    it 'creates the /etc/sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content(/Defaults      !lecture,tty_tickets,!fqdn/)
    end
  end

  context 'with custom prefix' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['authorization']['sudo']['prefix'] = '/secret/etc'
      end.converge(described_recipe)
    end

    it 'creates the sudoers file in the custom location' do
      expect(chef_run).to render_file('/secret/etc/sudoers').with_content(/Defaults      !lecture,tty_tickets,!fqdn/)
    end
  end

  context "node['authorization']['sudo']['users']" do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['authorization']['sudo']['prefix'] = '/secret/etc'
        node.set['authorization']['sudo']['users'] = %w(bacon)
      end.converge(described_recipe)
    end

    it 'adds users of the bacon group to the sudoers file' do
      expect(chef_run).to render_file('/secret/etc/sudoers').with_content(/^bacon/)
    end
  end

  context "node['authorization']['sudo']['groups']" do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['authorization']['sudo']['groups'] = %w(bacon)
      end.converge(described_recipe)
    end

    it 'adds users of the bacon group to the sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('%bacon ALL=(ALL) ALL')
    end
  end

  context "node['authorization']['sudo']['passwordless']" do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['authorization']['sudo']['users'] = %w(bacon)
        node.set['authorization']['sudo']['groups'] = %w(bacon)
        node.set['authorization']['sudo']['passwordless'] = true
      end.converge(described_recipe)
    end

    it 'gives users and groups passwordless sudo' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('bacon ALL=(ALL) NOPASSWD:ALL')
      expect(chef_run).to render_file('/etc/sudoers').with_content('%bacon ALL=(ALL) NOPASSWD:ALL')
    end
  end

  context "node['authorization']['sudo']['agent_forwarding']" do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['authorization']['sudo']['agent_forwarding'] = true
      end.converge(described_recipe)
    end

    it 'includes ssh forwarding in the sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      env_keep+=SSH_AUTH_SOCK')
    end
  end

  context "node['authorization']['sudo']['sudoers_defaults']" do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['authorization']['sudo']['sudoers_defaults'] = %w(ham bacon)
      end.converge(described_recipe)
    end

    it 'includes each default' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      ham')
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      bacon')
    end
  end

  context "node['authorization']['sudo']['prefix']" do
    context 'on SmartOS' do
      let(:chef_run) { ChefSpec::Runner.new(platform: 'smartos', version: 'joyent_20130111T180733Z').converge(described_recipe) }

      it 'uses /opt/local/etc' do
        expect(chef_run).to create_template('/opt/local/etc/sudoers')
      end
    end

    context 'on Ubuntu' do
      let(:chef_run) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe) }

      it 'uses /etc' do
        expect(chef_run).to create_template('/etc/sudoers')
      end
    end
  end

  context "node['authorization']['sudo']['command_aliases']" do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['authorization']['sudo']['command_aliases'] =
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

  context 'sudoers.d' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['authorization']['sudo']['include_sudoers_d'] = true
      end.converge(described_recipe)
    end

    it 'creates the sudoers.d directory' do
      expect(chef_run).to create_directory('/etc/sudoers.d').with(
        owner: 'root',
        mode: '0755'
      )
    end
  end
end
