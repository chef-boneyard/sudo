#
# This cookbook is just a wrapper around sudo::default, but is
# required so we load the attributes defined in the default attributes
# file for this cookbook. Otherwise, vagrant can't actually complete
# its Chef run.
#

include_recipe 'sudo::default'
