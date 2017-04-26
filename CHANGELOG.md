# sudo Cookbook CHANGELOG

This file is used to list changes made in each version of the sudo cookbook.

## 3.4.0 (2017-04-26)

- Add lwrp support for only env_keep add/subtract
- Readme improvements
- Move the files out of the default directory since Chef >= 12 doesn't require this
- Test with Local Delivery instead of Rake
- Cookstyle fixes
- Update apache2 license string

## 3.3.1 (2017-01-17)

- fixed command_aliases in README

## 3.3.0 (2017-01-04)

- Add attributes for env_keep_add and env_keep_subtract for the base sudoers file
- Sanitize file names in the :remove action so we remove the proper files

## 3.2.0 (2016-12-27)

- Convert ~ to __ like we do for i (sudoers.d files)

## 3.1.0 (2016-10-24)
- add attribute custom_commands for user and group

## 3.0.0 (2016-09-08)
- Testing updates
- Require Chef 12.1+

## 2.11.0 (2016-08-09)
- Add support for NOEXEC flag

## v2.10.0 (2016-08-04)

- Added a warning to the LWRP if include_sudoers_d is set to false
- Enabled use_inline_resources in the LWRP
- Added IBM zlinux as a supported platform
- Added suse, opensuse, and opensuseleap to the metadata as they are now tested platforms
- Added chef_version metadata to metadata.rb
- Removed attributes from the metadata.rb as this serves little purpose
- Converted bats integration tests to inspec
- Switched from rubocop to cookstyle for Ruby linting
- Removed the need for the apt cookbook in the test suite by using the apt_update resource instead
- Switched from kitchen-docker to kitchen-dokken and enabled Debian/Opensuse platforms in Travis

## v2.9.0 (2016-02-07)

- Updated the provider to avoid writing out config files with periods in the filename when a user has a period in their name as these are skipped by the sudo package. A sudo config for invalid.user will write out a config named invalid_user now.

## v2.8.0 (2016-02-04)

- Added a new attribute to the recipe and provider for adding SETENV to sudoer config
- Updated development deps to the latest version
- Setup test kitchen to run in Travis with kitchen-docker
- Expanded the kitchen.yml config to include additional platforms
- Renamed the test recipe from fake to test
- Updated the testing and contributing docs to the latest
- Added maintainers.toml and maitainers.md
- Added a chefignore file to limit which files get uploaded to the chef server
- Added long_description to the metadata.rb
- Added source_url and issues_url for Supermarket to the metadata.rb
- Resolved all Rubocop warnings
- Updated the Chefspec to the 4.x format
- Removed kitchen cloud testing configs and gem deps
- Removed the Guardfile and the gem deps

## v2.7.2 (2015-07-10)

- Adding support for keep_env
- misc cleanup

## v2.7.1 (2014-09-18)

- [#53] - removed double space from sudoer.erb template

## v2.7.0 (2014-08-08)

- [#44] Add basic ChefSpec matchers

## v2.6.0 (2014-05-15)

- [COOK-4612] Add support for the command alias (Cmnd_Alias) directive
- [COOK-4637] - handle duplicate resources in LWRP

## v2.5.2 (2014-02-27)

Bumping version for toolchain sanity

## v2.5.0 (2014-02-27)

Bumping to 2.5.0

## v2.4.2 (2014-02-27)

[COOK-4350] - Fix issue with "Defaults" line in sudoer.erb

## v2.4.0 (2014-02-18)

**BREAKING CHANGE**: The `sysadmin` group has been removed from the template. You will lose sudo access if:

- You have users that depend on the sysadmin group for sudo access, and
- You are overriding authorization.sudo.groups, but not including `sysadmin` in the list of groups

### Bug

- **[COOK-4225](https://tickets.chef.io/browse/COOK-4225)** - Mac OS X: /etc/sudoers: syntax error when include_sudoers_d is true

### Improvement

- **[COOK-4014](https://tickets.chef.io/browse/COOK-4014)** - It should be possible to remove the 'sysadmin' group setting from /etc/sudoers
- **[COOK-3643](https://tickets.chef.io/browse/COOK-3643)** - FreeBSD support for sudo cookbook

### New Feature

- **[COOK-3409](https://tickets.chef.io/browse/COOK-3409)** - enhance sudo lwrp's default template to allow defining default user parameters

## v2.3.0

### Improvement

- **[COOK-3843](https://tickets.chef.io/browse/COOK-3843)** - Make cookbook 'sudo' compatible with Mac OS X

## v2.2.2

### Improvement

- **[COOK-3653](https://tickets.chef.io/browse/COOK-3653)** - Change template attribute to kind_of String
- **[COOK-3572](https://tickets.chef.io/browse/COOK-3572)** - Add Test Kitchen, Specs, and Travis CI

### Bug

- **[COOK-3610](https://tickets.chef.io/browse/COOK-3610)** - Document "Runas" attribute not described in the LWRP Attributes section
- **[COOK-3431](https://tickets.chef.io/browse/COOK-3431)** - Validate correctly with `visudo`

## v2.2.0

### New Feature

- **[COOK-3056](https://tickets.chef.io/browse/COOK-3056)** - Allow custom sudoers config prefix

## v2.1.4

This is a bugfix for 11.6.0 compatibility, as we're not monkey-patching Erubis::Context.

### Bug

- [COOK-3399]: Remove node attribute in comment of sudoers templates

## v2.1.2

### Bug

- [COOK-2388]: Chef::ShellOut is deprecated, please use Mixlib::ShellOut
- [COOK-2814]: Incorrect syntax in README example

## v2.1.0

- [COOK-2388] - Chef::ShellOut is deprecated, please use Mixlib::ShellOut
- [COOK-2427] - unable to install users cookbook in chef 11
- [COOK-2814] - Incorrect syntax in README example

## v2.0.4

- [COOK-2078] - syntax highlighting README on GitHub flavored markdown
- [COOK-2119] - LWRP template doesn't support multiple commands in a single block.

## v2.0.2

- [COOK-2109] - lwrp uses incorrect action on underlying file resource.

## v2.0.0

This is a major release because the LWRP's "nopasswd" attribute is changed from true to false, to match the passwordless attribute in the attributes file. This requires a change to people's LWRP use.

- [COOK-2085] - Incorrect default value in the sudo LWRP's nopasswd attribute

## v1.3.0

- [COOK-1892] - Revamp sudo cookbook and LWRP
- [COOK-2022] - add an attribute for setting /etc/sudoers Defaults

## v1.2.2

- [COOK-1628] - set host in sudo lwrp

## v1.2.0

- [COOK-1314] - default package action is now :install instead of :upgrade
- [COOK-1549] - Preserve SSH agent credentials upon sudo using an attribute

## v1.1.0

- [COOK-350] - LWRP to manage sudo files via include dir (/etc/sudoers.d)

## v1.0.2

- [COOK-903] - freebsd support
