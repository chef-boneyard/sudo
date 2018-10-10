#
# Cookbook:: sudo
# Resource:: default
#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Author:: Seth Vargo (<sethvargo@gmail.com>)
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Copyright:: 2011-2018, Bryan w. Berry
# Copyright:: 2012-2018, Seth Vargo
# Copyright:: 2015-2018, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

chef_version_for_provides '< 14.0' if respond_to?(:chef_version_for_provides)
resource_name :sudo

# acording to the sudo man pages sudo will ignore files in an include dir that have a `.` or `~`
# We convert either to `__`
property :filename, String, name_property: true, coerce: proc { |x| x.gsub(/[\.~]/, '__') }
property :users, [String, Array], default: [], coerce: proc { |x| x.is_a?(Array) ? x : x.split(/\s*,\s*/) }
property :groups, [String, Array], default: [], coerce: proc { |x| coerce_groups(x) }
property :commands, Array, default: ['ALL']
property :host, String, default: 'ALL'
property :runas, String, default: 'ALL'
property :nopasswd, [true, false], default: false
property :noexec, [true, false], default: false
property :template, String
property :variables, [Hash, nil], default: nil
property :defaults, Array, default: []
property :command_aliases, Array, default: []
property :setenv, [true, false], default: false
property :env_keep_add, Array, default: []
property :env_keep_subtract, Array, default: []
property :visudo_path, String # legacy placeholder for cookbook users. We raise when used below
property :visudo_binary, String, default: '/usr/sbin/visudo'
property :config_prefix, String, default: lazy { platform_config_prefix }

# handle legacy cookbook property
def after_created
  raise "The 'visudo_path' property from the sudo cookbook has been replaced with the 'visudo_binary' property. The path is now more intelligently determined and for most users specifying the path should no longer be necessary. If this resource still cannot determine the path to visudo then provide the full path to the binary with the 'visudo_binary' property." if visudo_path
end

# VERY old legacy properties
alias_method :user, :users
alias_method :group, :groups

# make sure each group starts with a %
def coerce_groups(x)
  # split strings on the commas with optional spaces on either side
  groups = x.is_a?(Array) ? x : x.split(/\s*,\s*/)

  # make sure all the groups start with %
  groups.map { |g| g[0] == '%' ? g : "%#{g}" }
end

# default config prefix paths based on platform
# @return [String]
def platform_config_prefix
  case node['platform_family']
  when 'smartos'
    '/opt/local/etc'
  when 'mac_os_x'
    '/private/etc'
  when 'freebsd'
    '/usr/local/etc'
  else
    '/etc'
  end
end

# Validates if each element in an array starts with `/` or is in
# ALL_CAPS. This is helpful for ensuring that the commands
# passing into the sudoers resource as they need a full path or a
# `Cmnd_Alias`. This should help people more easily catch issues
# where the user requested `tail SOME_ARGS SOME_FILE` where they
# need to use `/usr/bin/tail SOME_ARGS SOME_FILE`.
# return [TrueClass, FalseClass]
def validate_commands_path(commands)
  commands.each do |command|
    cmd = command.split(' ').first
    if command.start_with?('/') || cmd.upcase == cmd
      true
    else
      false
    end
  end
end

# Default action - install a single sudoer
action :create do
  validate_properties

  if docker? # don't even put this into resource collection unless we're in docker
    declare_resource(:package, 'sudo') do
      action :nothing
      not_if 'which sudo'
    end.run_action(:install)
  end

  target = "#{new_resource.config_prefix}/sudoers.d/"
  declare_resource(:directory, target) unless ::File.exist?(target)

  Chef::Log.warn("#{new_resource.filename} will be rendered, but will not take effect because the #{new_resource.config_prefix}/sudoers config lacks the includedir directive that loads configs from #{new_resource.config_prefix}/sudoers.d/!") if ::File.readlines("#{new_resource.config_prefix}/sudoers").grep(/includedir/).empty?

  if new_resource.commands && !validate_commands_path(new_resource.commands)
    Chef::Log.fatal('To restrict sudoer commands you must use absolute paths. For example to use `tail` you must specify `/usr/bin/tail` or whatever the appropriate path is for your system. This is becase someone could create a command called `tail` and put it in their path, sudo does not know which one to allow.')
  end

  if new_resource.template
    Chef::Log.debug('Template property provided, all other properties ignored.')

    declare_resource(:template, "#{target}#{new_resource.filename}") do
      source new_resource.template
      mode '0440'
      variables new_resource.variables
      verify "#{new_resource.visudo_binary} -cf %{path}" if visudo_present?
      action :create
    end
  else
    declare_resource(:template, "#{target}#{new_resource.filename}") do
      source 'sudoer.erb'
      cookbook 'sudo'
      mode '0440'
      variables sudoer:            (new_resource.groups + new_resource.users).join(','),
                host:               new_resource.host,
                runas:              new_resource.runas,
                nopasswd:           new_resource.nopasswd,
                noexec:             new_resource.noexec,
                commands:           new_resource.commands,
                command_aliases:    new_resource.command_aliases,
                defaults:           new_resource.defaults,
                setenv:             new_resource.setenv,
                env_keep_add:       new_resource.env_keep_add,
                env_keep_subtract:  new_resource.env_keep_subtract
      verify "#{new_resource.visudo_binary} -cf %{path}" if visudo_present?
      action :create
    end
  end
end

action :install do
  Chef::Log.warn('The sudo :install action has been renamed :create. Please update your cookbook code for the new action')
  action_create
end

action :remove do
  Chef::Log.warn('The sudo :remove action has been renamed :delete. Please update your cookbook code for the new action')
  action_delete
end

# Removes a user from the sudoers group
action :delete do
  file "#{new_resource.config_prefix}/sudoers.d/#{new_resource.filename}" do
    action :delete
  end
end

action_class do
  # Ensure that the inputs are valid (we cannot just use the resource for this)
  def validate_properties
    # if group, user, env_keep_add, env_keep_subtract and template are nil, throw an exception
    raise 'You must specify users, groups, env_keep_add, env_keep_subtract, or template properties!' if new_resource.users.empty? && new_resource.groups.empty? && new_resource.template.nil? && new_resource.env_keep_add.empty? && new_resource.env_keep_subtract.empty?

    # if specifying user or group and template at the same time fail
    raise 'You cannot specify users or groups properties and also specify a template. To use your own template pass in all template variables using the variables property.' if (!new_resource.users.empty? || !new_resource.groups.empty?) && !new_resource.template.nil?
  end

  def visudo_present?
    return true if ::File.exist?(new_resource.visudo_binary)
    Chef::Log.warn("The visudo binary cannot be found at '#{new_resource.visudo_binary}'. Skipping sudoer file validation. If visudo is on this system you can specify the path using the 'visudo_binary' property.")
  end
end
