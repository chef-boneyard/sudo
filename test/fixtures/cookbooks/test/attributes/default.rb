# Add default users for sudo so testing doesn't end up in a
# broken system where the default user cannot sudo
default['authorization']['sudo']['users'] = %w(vagrant root)

# Make sure sudo is passwordless for tests
default['authorization']['sudo']['passwordless'] = true

# Include sudoers.d
default['authorization']['sudo']['include_sudoers_d'] = true
