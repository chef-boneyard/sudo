describe file('/etc/sudoers.d') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 493 }
end

describe file('/etc/sudoers.d/README') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 288 }
  its('content') { should match(/As of Debian version/) }
end

describe file('/etc/sudoers') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should eq 288 }
end
