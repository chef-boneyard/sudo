name 'sudo'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs sudo and configures /etc/sudoers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.9.0'

recipe 'sudo', 'Installs sudo and configures /etc/sudoers'

%w(redhat centos fedora ubuntu debian freebsd mac_os_x oracle scientific).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/sudo' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/sudo/issues' if respond_to?(:issues_url)

attribute 'authorization',
  display_name: 'Authorization',
  description: 'Hash of Authorization attributes',
  type: 'hash'

attribute 'authorization/sudo',
  display_name: 'Authorization Sudoers',
  description: 'Hash of Authorization/Sudo attributes',
  type: 'hash'

attribute 'authorization/sudo/users',
  display_name: 'Sudo Users',
  description: 'Users who are allowed sudo ALL',
  type: 'array',
  default: ''

attribute 'authorization/sudo/groups',
  display_name: 'Sudo Groups',
  description: 'Groups who are allowed sudo ALL',
  type: 'array',
  default: ''

attribute 'authorization/sudo/passwordless',
  display_name: 'Passwordless Sudo',
  description: '',
  type: 'string',
  default: 'false'

attribute 'authorization/sudo/include_sudoers_d',
  display_name: 'Include sudoers.d',
  description: 'Whether to create the sudoers.d includedir',
  type: 'string',
  default: 'false'

attribute 'authorization/sudo/setenv',
  display_name: 'SetEnv Sudo',
  description: 'Whether to permit the preserving of environment via sudo -E',
  type: 'string',
  default: 'false'
