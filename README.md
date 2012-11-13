Chef sudo cookbook
==================
The Chef `sudo` cookbook installs the `sudo` package and configures the `/etc/sudoers` file.

It also exposes an LWRP for adding and managing sudoers.

Requirements
------------
The platform has a package named `sudo` and the `sudoers` file is `/etc/sudoers`.

Attributes
----------
- `node['authorization']['sudo']['groups']` - groups to enable sudo access (default: `[]`)
- `node['authorization']['sudo']['users']` - users to enable sudo access (default: `[]`)
- `node['authorization']['sudo']['passwordless']` - use passwordless sudo (default: `false`)
- `node['authorization']['sudo']['include_sudoers_d']` - include and manager `/etc/sudoers.d` (default: `false`)
- `node['authorization']['sudo']['agent_forwarding']` - preserve `SSH_AUTH_SOCK` when sudoing (default: `false`)


Usage
-----
#### Attributes
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


#### LWRP
**Note** Sudo version 1.7.2 or newer is required to use the sudo LWRP as it relies on the "#includedir" directive introduced in version 1.7.2. The recipe does not enforce installing the version. To use this LWRP, set `node['authorization']['sudo']['include_sudoers_d']` to `true`.

There are two ways for rendering a sudoer-fragment using this LWRP:

  1. Using the built-in template
  2. Using a custom, cookbook-level template

Both methods will create the `/etc/sudoers.d/#{username}` file with the correct permissions.

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
sudo 'tomcat'
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

##### LWRP Attributes
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
      <td>user</td>
      <td>user to provide sudo privileges to</td>
      <td><tt>tomcat</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>group</td>
      <td>group to provide sudo privileges to, except `%` is prepended to the name in
case it is not already</td>
      <td><tt>%admin</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>commands</td>
      <td>array of commands this sudoer can execute</td>
      <td><tt>['/etc/init.d/tomcat restart']</tt></td>
      <td><tt>['ALL']</tt></td>
    </tr>
    <tr>
      <td>nopasswd</td>
      <td>supply a password to invoke sudo</td>
      <td><tt>true</tt></td>
      <td><tt>false</tt></td>
    </tr>
    <tr>
      <td>template</td>
      <td>the erb template to render instead of the default</td>
      <td><tt>restart-tomcat.erb</tt></td>
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


License and Authors
-------------------
- Author:: Bryan W. Berry <bryan.berry@gmail.com>
- Author:: Adam Jacob <adam@opscode.com>
- Author:: Seth Chisamore <schisamo@opscode.com>
- Author:: Seth Vargo <sethvargo@gmail.com>

Copyright 2009-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
