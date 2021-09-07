name 'sudo'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs sudo and configures /etc/sudoers'
version '5.4.7'

%w(aix amazon redhat centos fedora ubuntu debian freebsd mac_os_x oracle scientific zlinux suse opensuse opensuseleap).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/sudo'
issues_url 'https://github.com/chef-cookbooks/sudo/issues'
chef_version '>= 12.21.3'
