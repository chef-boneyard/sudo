include_recipe 'test::default'
include_recipe 'test::create'

%w(
  tomcat
  bob
  invalid.user
  tilde-invalid~user
  ~bob
  alice
  git
  jane
  ops
).each do |sudoer|
  sudo sudoer do
    action :remove
  end
end
