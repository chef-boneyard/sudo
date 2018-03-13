#
# Cookbook:: sudo
# Recipe:: default
#
# Copyright:: 2008-2018, Chef Software, Inc.
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
#

config_prefix = case node['platform_family']
                when 'smartos'
                  '/opt/local/etc'
                when 'freebsd'
                  '/usr/local/etc'
                when 'mac_os_x'
                  '/private/etc'
                else
                  '/etc'
                end

if node['authorization']['sudo']['include_sudoers_d']
  directory "#{config_prefix}/sudoers.d" do
    mode node['authorization']['sudo']['sudoers_d_mode']
    owner 'root'
    group node['root_group']
  end

  cookbook_file "#{config_prefix}/sudoers.d/README" do
    mode '0440'
    owner 'root'
    group node['root_group']
  end
end

template "#{config_prefix}/sudoers" do
  source 'sudoers.erb'
  mode '0440'
  owner 'root'
  group node['root_group']
  variables(
    sudoers_groups: node['authorization']['sudo']['groups'],
    sudoers_users: node['authorization']['sudo']['users'],
    passwordless: node['authorization']['sudo']['passwordless'],
    setenv: node['authorization']['sudo']['setenv'],
    include_sudoers_d: node['authorization']['sudo']['include_sudoers_d'],
    agent_forwarding: node['authorization']['sudo']['agent_forwarding'],
    sudoers_defaults: node['authorization']['sudo']['sudoers_defaults'],
    command_aliases: node['authorization']['sudo']['command_aliases'],
    env_keep_add: node['authorization']['sudo']['env_keep_add'],
    env_keep_subtract: node['authorization']['sudo']['env_keep_subtract'],
    custom_commands_users: node['authorization']['sudo']['custom_commands']['users'],
    custom_commands_groups: node['authorization']['sudo']['custom_commands']['groups'],
    config_prefix: config_prefix
  )
end
