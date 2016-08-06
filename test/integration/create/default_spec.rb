# doesn't create defaults for specific sudo resource if no defaults are set (COOK-3409)
describe file('/etc/sudoers.d/bob') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 288 }
  its('content') { should should_not match(/^Defaults:bob/) }
end

describe file('/etc/sudoers.d/tomcat') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 288 }
  # each app has its own line COOK-2119
  its('content') { should match(/^%tomcat ALL=\(app_user\) \/etc\/init.d\/tomcat restart$\n^%tomcat ALL=\(app_user\) \/etc\/init.d\/tomcat stop$\n^%tomcat ALL=\(app_user\) \/etc\/init.d\/tomcat start$/m) }
  # sudo defaults for specific sudo resources (COOK-3409)
  its('content') { should match(/^Defaults:%tomcat \!requiretty,env_reset/) }
end

# supports providing command aliases for sudo usage (COOK-4612)
describe file('/etc/sudoers.d/alice') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 288 }
  its('content') { should match(/^Cmnd_Alias STARTSSH = \/etc\/init.d\/ssh start, \/etc\/init.d\/ssh restart, ! \/etc\/init.d\/ssh stop$/) }
  its('content') { should match(/^alice ALL=\(ALL\) STARTSSH$/) }
end

# supports the setting of SETENV for preserving the sudo environment
describe file('/etc/sudoers.d/git') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 288 }
  its('content') { should match(/^git ALL=\(phabricator\) NOPASSWD:SETENV:\/usr\/bin\/git-upload-pack$/) }
end

# it munges a user with a dot in it
describe file('/etc/sudoers.d/invalid__user') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 288 }
end

# supports setting the NOEXEC flag
describe file('/etc/sudoers.d/jane') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 288 }
  its('content') { should match(/^jane ALL=\(ALL\) NOEXEC: \/usr\/bin\/less$/) }
end
