# sudo Cookbook CHANGELOG

This file is used to list changes made in each version of the sudo cookbook.

## 5.4.7 (2021-09-06)

- Deprecating this cookbook. The sudo resource ships in Chef Infra Client 14 and later.

## 5.4.6 (2020-06-08)

- Support Chef Infra Client 16.2+  - [@tas50](https://github.com/tas50)
- Testing updates - [@tas50](https://github.com/tas50)
- Fix failing specs - [@tas50](https://github.com/tas50)
- Use the org wide GitHub templates - [@tas50](https://github.com/tas50)

## 5.4.5 (2019-12-03)

- Remove Ubuntu 14.04 testing for 18.04 - [@tas50](https://github.com/tas50)
- Cookstyle fixes - [@tas50](https://github.com/tas50)
- Remove unnecessary metadata - [@tas50](https://github.com/tas50)
- Metadata syntax issue cookbook failed in chef:12 - [@amalsom10](https://github.com/amalsom10)
- Minor testing updates - [@tas50](https://github.com/tas50)

## 5.4.4 (2018-10-09)

- Fix the command validation method

## 5.4.3 (2018-10-09)

- adds better validation for commands passed in

## 5.4.2 (2018-09-04)

The `sudo` resource is now built into Chef 14+. When Chef 15 is released (April 2019) this resource will be removed from this cookbook as all users should be on Chef 14+.

## 5.4.1 (2018-08-29)

- Avoid deprecation warnings with Chef 14.3+ by not loading resources that are now built into Chef

## 5.4.0 (2018-04-26)

- Add support for aix

## 5.3.3 (2018-03-22)

- Properly deprecate the undocumented visudo_path property for visudo_binary. Without realizing it later on when I went to make a release I changed the behavior of this property. It was never documented in the readme or the changelog so I suspect few people are using it, but just in case we fail hard on the old name now with helpful messaging.
- Properly return true in method that looks for visudo
- Avoid name conflicts between properties and the path helper method

## 5.3.2 (2018-03-22)

- Restore resource behavior on FreeBSD.

## 5.3.1 (2018-03-13)

- Use visudo_path property to override the path to visudo
- Handle poorly deliminated strings in the users property
- Add backwards compatibility for the :delete action

## 5.3.0 (2018-03-13)

- Use the includedir directive on Solaris and macOS in addition to Linux. All three of these platforms support it out of the box on non-EOL releases
- Fail with a useful message in the resource when on FreeBSD since FreeBSD doesn't support sudoers.d`
- Skip / warn if visudo isn't present where we expect it to be instead of failing hard
- Fully support macOS in the resource and recipe

## 5.2.0 (2018-03-13)

- Refactored the resource to use Chef's built in template verification functionality. This avoids a lot of custom work we did in the resource to verify the config file before we wrote it out. Not only does this reduce code complexity/fragility in this cookbook, it removes the double template resource you'd see in converges before.

## 5.1.0 (2018-03-13)

- Rework the readme to with additional documentation on the resource
- Fix a compilation failure if the user was specifying their own template
- Improve the conditions in which the property validation fails
- Renamed the group property to groups with backwards compatibility
- Renamed the user property to users with backwards compatibility
- Change the type of users/groups to Arrays so you can either specify comma separated lists or arrays of users/groups
- Improve the splitting of the list of users/groups to handle spaces before/after the commas
- Properly add % to each group name in arrays as well as comma separated lists. Also support the scenario where one group has a % and the other does not
- Support setting up sudo for both users and groups in the same config. We now combine the users and groups as you would expect

## 5.0.0 (2018-03-11)

- Converted the LWRP to a custom resource
- Changed the package install logic to only try to install sudo when we're on a docker guest where sudo is generally missing. This uses the docker? helper which requires 12.21.3, which is the new minimum Chef version supported by this cookbook
- The property validation logic previously in the resource is now actually run. This prevents combinations of resources that will not work together from being used.
- Reordered the readme to list the resource first as this is the preferred way to use this resource
- Removed the `node['authorization']['sudo']['prefix']` attribute. In the recipe this is automatically determined. In the resource there is a new `config_prefix` property. This should have no impact on users as the proper settings for each OS are still specified.
- Added a new filename name_property is you want to specify the filename as something different than the resource's name. This helps avoid resource cloning issues.
- The `:install` action has been renamed to `:create`, while retaining backwards compatibility with the old name
- Resolved FC085 Foodcritic warning

## 4.0.1 (2018-02-16)

- FIX: in templates the attribute "passwordless" and other with data type String always will be return true
- Add an attribute for setting sudoers.d mode
- Removed the ChefSpec matchers. These are now autogenerated by ChefSpec. If you are seeing matcher failure upgrade to ChefDK 2.4 or later.

## 4.0.0 (2017-11-28)

### Breaking Changes

- sudo .d functionality is now enabled by default on Linux systems. This allows the sudo resource to function with setting `node['authorization']['sudo']['include_sudoers_d']` to true. Only some older / EoL distros this will break sudo functionality so make sure you test this and set it to false if you're running an EoL distro
- The `sysadmin` group is no longer added to sudoers by default anymore. Historically many community cookbooks assumed all admins were in this sysadmins group. We've moved away from that assumption since it was a suprise to many when this group was added. If you rely on this behavior make sure to `node['authorization']['sudo']['groups']` attribute to inlude the sysadmin group.

### Other Changes

- Remove the debian-isms from the sudo.d readme file which is copied onto multiple Linux systems
- Remove an old RHEL 5 example from the readme
- Fix ChefSpec warnings
- Improve Travis testing and add Debian 9 testing
- Setenv for restricted users
- Improve visudo path resolution on non-Debian distros

## 3.5.3 (2017-07-09)

- Add amazon linux to the metadata
- Remove extra spaces in the sudoer template
- Update platform names in the readme
- Replace the HTML table with markdown

## 3.5.2 (2017-06-26)

- Remove totally bogus "supports" attribute from the resource
- Revert "Remove sysadmin from default groups". We'll handle this differently going forward. Sorry for the breakage

## 3.5.1 (2017-06-21)

- Remove sysadmin from default groups as sysadmin is no longer a group we push via the users cookbook.

## 3.5.0 (2017-05-16)

- Add sudo package management to resource

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
