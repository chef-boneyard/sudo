%w(
  tomcat
  bob
  invalid__user
  tilde-invalid__user
  __bob
  alice
  git
  jane
).each do |sudoer|
  describe file("/etc/sudoers.d/#{sudoer}") do
    it { should_not exist }
  end
end
