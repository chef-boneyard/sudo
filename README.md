# sudo cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/sudo.svg?branch=master)](http://travis-ci.org/chef-cookbooks/sudo) [![Cookbook Version](https://img.shields.io/cookbook/v/sudo.svg)](https://supermarket.chef.io/cookbooks/sudo)

The default recipe configures the `/etc/sudoers` file.

## Deprecation

The sudo resource is now included in Chef Infra Client 14 and later. This cookbook is no longer necessary and should not be used. Used the resource directly https://docs.chef.io/resources/sudo/

## Requirements

### Platforms

- AIX
- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle
- Amazon Linux
- FreeBSD
- macOS
- openSUSE / SUSE Enterprise

### Chef

- Chef 14+

### Cookbooks

- None

### Attributes

- `node['authorization']['sudo']['groups']` - groups to enable sudo access (default: `[]`)
- `node['authorization']['sudo']['users']` - users to enable sudo access (default: `[]`)
- `node['authorization']['sudo']['passwordless']` - use passwordless sudo (default: `false`)
- `node['authorization']['sudo']['include_sudoers_d']` - include and manage `/etc/sudoers.d` (default: `true` on Linux systems. Note: older / EOL distros do not support this feature)
- `node['authorization']['sudo']['agent_forwarding']` - preserve `SSH_AUTH_SOCK` when sudoing (default: `false`)
- `node['authorization']['sudo']['sudoers_defaults']` - Array of `Defaults` entries to configure in `/etc/sudoers`
- `node['authorization']['sudo']['setenv']` - Whether to permit preserving of environment with `sudo -E` (default: `false`)

### Using the Attributes

To use attributes for defining sudoers, set the attributes above on the node (or role) itself:

```json
{
  "default_attributes": {
    "authorization": {
      "sudo": {
        "groups": ["admin", "wheel", "sysadmin"],
        "users": ["jerry", "greg"],
        "passwordless": "true"
      }
    }
  }
}
```

```json
{
  "default_attributes": {
    "authorization": {
      "sudo": {
        "command_aliases": [{
          "name": "TEST",
          "command_list": [
            "/usr/bin/ls",
            "/usr/bin/cat"
          ]
        }],
        "custom_commands": {
          "users": [
            {
              "user": "test_user",
              "passwordless": true,
              "command_list": [
                "TEST"
              ]
            }
          ],
          "groups": [
            {
              "group": "test_group",
              "passwordless": false,
              "command_list": [
                "TEST"
              ]
            }
          ]
        }
      }
    }
  }
}
```

```ruby
# roles/example.rb
default_attributes(
  "authorization" => {
    "sudo" => {
      "groups" => ["admin", "wheel", "sysadmin"],
      "users" => ["jerry", "greg"],
      "passwordless" => true
    }
  }
)
```

**Note that the template for the sudoers file has the group "sysadmin" with ALL:ALL permission, though the group by default does not exist.**

### Sudoers Defaults

Configure a node attribute, `node['authorization']['sudo']['sudoers_defaults']` as an array of `Defaults` entries to configure in `/etc/sudoers`. A list of examples for common platforms is listed below:

_Debian_

```ruby
node.default['authorization']['sudo']['sudoers_defaults'] = ['env_reset']
```

_Ubuntu_

```ruby
node.default['authorization']['sudo']['sudoers_defaults'] = [
  'env_reset',
  'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
]
```

_FreeBSD_

```ruby
node.default['authorization']['sudo']['sudoers_defaults'] = [
  'env_reset',
  'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
]
```

_RHEL family 6.x_

```ruby
node.default['authorization']['sudo']['sudoers_defaults'] = [
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
```

_macOS_

```ruby
node.default['authorization']['sudo']['sudoers_defaults'] = [
  'env_reset',
  'env_keep += "BLOCKSIZE"',
  'env_keep += "COLORFGBG COLORTERM"',
  'env_keep += "__CF_USER_TEXT_ENCODING"',
  'env_keep += "CHARSET LANG LANGUAGE LC_ALL LC_COLLATE LC_CTYPE"',
  'env_keep += "LC_MESSAGES LC_MONETARY LC_NUMERIC LC_TIME"',
  'env_keep += "LINES COLUMNS"',
  'env_keep += "LSCOLORS"',
  'env_keep += "TZ"',
  'env_keep += "DISPLAY XAUTHORIZATION XAUTHORITY"',
  'env_keep += "EDITOR VISUAL"',
  'env_keep += "HOME MAIL"'
]
```

## Maintainers

This cookbook is maintained by Chef's Community Cookbook Engineering team. Our goal is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

**Copyright:** 2008-2018, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
