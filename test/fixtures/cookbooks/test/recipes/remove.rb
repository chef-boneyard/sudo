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
).each do |sudoer|
  sudo sudoer do
    action :remove
  end
end
