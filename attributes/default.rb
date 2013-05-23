#
# Cookbook Name:: sudo
# Attribute File:: default
#
# Copyright 2008-2011, Opscode, Inc.
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

default['authorization']['sudo']['groups']            = []
default['authorization']['sudo']['users']             = []
default['authorization']['sudo']['passwordless']      = false
default['authorization']['sudo']['include_sudoers_d'] = false
default['authorization']['sudo']['agent_forwarding']  = false

case platform_family
when 'debian'
  if platform_version < 12.04
    default['authorization']['sudo']['sudoers_defaults'] =  [
      'env_reset'
    ]
  else
    default['authorization']['sudo']['sudoers_defaults'] =  [
      'env_reset',
      'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
    ]
  end

when 'rhel'
  if platform_version.to_f  < 6.0
    default['authorization']['sudo']['sudoers_defaults'] =  [
      '!visiblepw',
      'env_reset',
      'env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR \
                   LS_COLORS MAIL PS1 PS2 QTDIR USERNAME \
                   LANG LC_ADDRESS LC_CTYPE LC_COLLATE LC_IDENTIFICATION \
                   LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC \
                   LC_PAPER LC_TELEPHONE LC_TIME LC_ALL LANGUAGE LINGUAS \
                   _XKB_CHARSET XAUTHORITY"'
    ]
  else
    default['authorization']['sudo']['sudoers_defaults'] =  [
      '!visiblepw',
      'env_reset',
      'env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"',
      'env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"',
      'env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"',
      'env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"',
      'env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"',
      'env_keep += "HOME"',
      'always_set_home',
      'secure_path = /sbin:/bin:/usr/sbin:/usr/bin'
    ]
  end

else
  default['authorization']['sudo']['sudoers_defaults'] =  [
    '!lecture, tty_tickets, !fqdn'
  ]
end
