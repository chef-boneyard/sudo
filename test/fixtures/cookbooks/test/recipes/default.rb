#
# This cookbook is just a wrapper around sudo::default, but is
# required so we load the attributes defined in the default attributes
# file for this cookbook. Otherwise, vagrant can't actually complete
# its Chef Infra Client run.
#

apt_update

include_recipe 'sudo::default'
