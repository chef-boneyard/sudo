# sudo cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/sudo.svg?branch=master)](http://travis-ci.org/chef-cookbooks/sudo) [![Cookbook Version](https://img.shields.io/cookbook/v/sudo.svg)](https://supermarket.chef.io/cookbooks/sudo)

The default recipe installs the `sudo` package and configures the `/etc/sudoers` file. The cookbook also includes a sudo resource to adding and removing individual sudo entries.

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle
- FreeBSD
- Mac OS X
- openSUSE / Suse

### Chef

- Chef 12.1+

### Cookbooks

- None

## Attributes

- `node['authorization']['sudo']['groups']` - groups to enable sudo access (default: `[ "sysadmin" ]`)
- `node['authorization']['sudo']['users']` - users to enable sudo access (default: `[]`)
- `node['authorization']['sudo']['passwordless']` - use passwordless sudo (default: `false`)
- `node['authorization']['sudo']['include_sudoers_d']` - include and manage `/etc/sudoers.d` (default: `false`)
- `node['authorization']['sudo']['agent_forwarding']` - preserve `SSH_AUTH_SOCK` when sudoing (default: `false`)
- `node['authorization']['sudo']['sudoers_defaults']` - Array of `Defaults` entries to configure in `/etc/sudoers`
- `node['authorization']['sudo']['setenv']` - Whether to permit preserving of environment with `sudo -E` (default: `false`)

## Usage

### Attributes

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

_Ubuntu 12.04_

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

_RHEL family 5.x_ The version of sudo in RHEL 5 may not support `+=`, as used in `env_keep`, so its a single string.

```ruby
node.default['authorization']['sudo']['sudoers_defaults'] = [
  '!visiblepw',
  'env_reset',
  'env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR \
               LS_COLORS MAIL PS1 PS2 QTDIR USERNAME \
               LANG LC_ADDRESS LC_CTYPE LC_COLLATE LC_IDENTIFICATION \
               LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC \
               LC_PAPER LC_TELEPHONE LC_TIME LC_ALL LANGUAGE LINGUAS \
               _XKB_CHARSET XAUTHORITY"'
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

_Mac OS X_

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

### Sudo Resource

**Note** Sudo version 1.7.2 or newer is required to use the sudo LWRP as it relies on the "#includedir" directive introduced in version 1.7.2. The recipe does not enforce installing the version. To use this LWRP, set `node['authorization']['sudo']['include_sudoers_d']` to `true`.

There are two ways for rendering a sudoer-fragment using this LWRP:
1. Using the built-in template
2. Using a custom, cookbook-level template

Both methods will create the `/etc/sudoers.d/#{resourcename}` file with the correct permissions.

The LWRP also performs **fragment validation**. If a sudoer-fragment is not valid, the Chef run will throw an exception and fail. This ensures that your sudoers file is always valid and cannot become corrupt (from this cookbook).

Example using the built-in template:

```ruby
sudo 'tomcat' do
  user      "%tomcat"    # or a username
  runas     'app_user'   # or 'app_user:tomcat'
  commands  ['/etc/init.d/tomcat restart']
end
```

```ruby
sudo 'tomcat' do
  template    'my_tomcat.erb' # local cookbook template
  variables   :cmds => ['/etc/init.d/tomcat restart']
end
```

In either case, the following file would be generated in `/etc/sudoers.d/tomcat`

```bash
# This file is managed by Chef for node.example.com
# Do NOT modify this file directly.

%tomcat ALL=(app_user) /etc/init.d/tomcat restart
```

#### Resource Properties

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Example</th>
      <th>Default</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>name</td>
      <td>name of the `/etc/sudoers.d` file</td>
      <td><tt>restart-tomcat</tt></td>
      <td>current resource name</td>
    </tr>
    <tr>
      <td>commands</td>
      <td>array of commands this sudoer can execute</td>
      <td><tt>['/etc/init.d/tomcat restart']</tt></td>
      <td><tt>['ALL']</tt></td>
    </tr>
    <tr>
      <td>group</td>
      <td>group to provide sudo privileges to, except `%` is prepended to the name in
case it is not already</td>
      <td><tt>%admin</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>nopasswd</td>
      <td>supply a password to invoke sudo</td>
      <td><tt>true</tt></td>
      <td><tt>false</tt></td>
    </tr>
    <tr>
      <td>noexec</td>
      <td>prevents commands from shelling out</td>
      <td><tt>true</tt></td>
      <td><tt>false</tt></td>
    </tr>
    <tr>
      <td>runas</td>
      <td>User the command(s) can be run as</td>
      <td><tt>root</tt></td>
      <td><tt>ALL</tt></td>
    </tr>
    <tr>
      <td>template</td>
      <td>the erb template to render instead of the default</td>
      <td><tt>restart-tomcat.erb</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>user</td>
      <td>user to provide sudo privileges to</td>
      <td><tt>tomcat</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>defaults</td>
      <td>array of defaults this user has</td>
      <td><tt>['!requiretty','env_reset']</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>setenv</td>
      <td>whether to permit the preserving of environment with `sudo -E`</td>
      <td><tt>true</tt></td>
      <td><tt><false></tt></td>
    </tr>
    <tr>
      <td>env_keep_add</td>
      <td>array of strings to add to env_keep</td>
      <td><tt>['HOME', 'MY_ENV_VAR MY_OTHER_ENV_VAR']</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>env_keep_subtract</td>
      <td>array of strings to remove from env_keep</td>
      <td><tt>['DISPLAY', 'MY_SECURE_ENV_VAR']</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>variables</td>
      <td>the variables to pass to the custom template</td>
      <td><tt>:commands => ['/etc/init.d/tomcat restart']</tt></td>
      <td></td>
    </tr>
  </tbody>
</table>

**If you use the template attribute, all other attributes will be ignored except for the variables attribute.**

## License & Authors

**Author:** Bryan W. Berry [bryan.berry@gmail.com](mailto:bryan.berry@gmail.com)

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2008-2016, Chef Software, Inc.

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
