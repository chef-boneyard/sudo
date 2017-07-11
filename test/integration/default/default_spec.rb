if os.linux?
  describe file('/etc/sudoers') do
    it { should be_file }
    it { should be_owned_by 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0440' }
  end

  describe directory('/etc/sudoers.d') do
    it { should be_owned_by 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0755' }
  end
else
  describe directory('/etc/sudoers.d') do
    it { should_not exist }
  end
end

describe file('/etc/sudoers.d/README') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0440' }
  its('content') { should match(/This will cause sudo to read and parse any files/) }
end
