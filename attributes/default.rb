#
# Cookbook:: sudo
# Attribute:: File:: default
#
# Copyright:: 2008-2016, Chef Software, Inc.
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

default['authorization']['sudo']['groups']            = ['sysadmin']
default['authorization']['sudo']['users']             = []
default['authorization']['sudo']['passwordless']      = false
default['authorization']['sudo']['setenv']            = false
default['authorization']['sudo']['include_sudoers_d'] = false
default['authorization']['sudo']['agent_forwarding']  = false
default['authorization']['sudo']['sudoers_defaults']  = ['!lecture,tty_tickets,!fqdn']
default['authorization']['sudo']['command_aliases']   = []
default['authorization']['sudo']['env_keep_add']      = []
default['authorization']['sudo']['env_keep_subtract'] = []
default['authorization']['sudo']['custom_commands']['users'] = []
default['authorization']['sudo']['custom_commands']['groups'] = []

default['authorization']['sudo']['prefix'] = case node['platform_family']
                                             when 'smartos'
                                               '/opt/local/etc'
                                             when 'freebsd'
                                               '/usr/local/etc'
                                             else
                                               '/etc'
                                             end
