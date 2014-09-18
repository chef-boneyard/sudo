v2.7.1 (2014-09-18)
-------------------
- [#53] - removed doublespace from sudoer.erb template

v2.7.0 (2014-08-08)
-------------------
- [#44] Add basic ChefSpec matchers

v2.6.0 (2014-05-15)
-------------------
- [COOK-4612] Add support for the command alias (Cmnd_Alias) directive
- [COOK-4637] - handle duplicate resources in LWRP


v2.5.2 (2014-02-27)
-------------------
Bumping version for toolchain sanity


v2.5.0 (2014-02-27)
-------------------
Bumping to 2.5.0


v2.4.2 (2014-02-27)
-------------------
[COOK-4350] - Fix issue with "Defaults" line in sudoer.erb


v2.4.0 (2014-02-18)
-------------------
### Bug
- **[COOK-4225](https://tickets.opscode.com/browse/COOK-4225)** - Mac OS X: /etc/sudoers: syntax error when include_sudoers_d is true

### Improvement
- **[COOK-4014](https://tickets.opscode.com/browse/COOK-4014)** - It should be possible to remove the 'sysadmin' group setting from /etc/sudoers
- **[COOK-3643](https://tickets.opscode.com/browse/COOK-3643)** - FreeBSD support for sudo cookbook

### New Feature
- **[COOK-3409](https://tickets.opscode.com/browse/COOK-3409)** - enhance sudo lwrp's default template to allow defining default user parameters


v2.3.0
------
### Improvement
- **[COOK-3843](https://tickets.opscode.com/browse/COOK-3843)** - Make cookbook 'sudo' compatible with Mac OS X


v2.2.2
------
### Improvement
- **[COOK-3653](https://tickets.opscode.com/browse/COOK-3653)** - Change template attribute to kind_of String
- **[COOK-3572](https://tickets.opscode.com/browse/COOK-3572)** - Add Test Kitchen, Specs, and Travis CI

### Bug
- **[COOK-3610](https://tickets.opscode.com/browse/COOK-3610)** - Document "Runas" attribute not described in the LWRP Attributes section
- **[COOK-3431](https://tickets.opscode.com/browse/COOK-3431)** - Validate correctly with `visudo`


v2.2.0
------
### New Feature
- **[COOK-3056](https://tickets.opscode.com/browse/COOK-3056)** - Allow custom sudoers config prefix

v2.1.4
------
This is a bugfix for 11.6.0 compatibility, as we're not monkey-patching Erubis::Context.

### Bug
- [COOK-3399]: Remove node attribute in comment of sudoers templates

v2.1.2
------
### Bug
- [COOK-2388]: Chef::ShellOut is deprecated, please use Mixlib::ShellOut
- [COOK-2814]: Incorrect syntax in README example

v2.1.0
------
* [COOK-2388] - Chef::ShellOut is deprecated, please use Mixlib::ShellOut
* [COOK-2427] - unable to install users cookbook in chef 11
* [COOK-2814] - Incorrect syntax in README example

v2.0.4
------
* [COOK-2078] - syntax highlighting README on GitHub flavored markdown
* [COOK-2119] - LWRP template doesn't support multiple commands in a single block.

v2.0.2
------
* [COOK-2109] - lwrp uses incorrect action on underlying file resource.

v2.0.0
------
This is a major release because the LWRP's "nopasswd" attribute is changed from true to false, to match the passwordless attribute in the attributes file. This requires a change to people's LWRP use.

* [COOK-2085] - Incorrect default value in the sudo LWRP's nopasswd attribute

v1.3.0
------
* [COOK-1892] - Revamp sudo cookbook and LWRP
* [COOK-2022] - add an attribute for setting /etc/sudoers Defaults

v1.2.2
------
* [COOK-1628] - set host in sudo lwrp

v1.2.0
------
* [COOK-1314] - default package action is now :install instead of :upgrade
* [COOK-1549] - Preserve SSH agent credentials upon sudo using an attribute

v1.1.0
------
* [COOK-350] - LWRP to manage sudo files via includedir (/etc/sudoers.d)

v1.0.2
------
* [COOK-903] - freebsd support
