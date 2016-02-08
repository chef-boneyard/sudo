include_recipe 'test::default'

sudo 'tomcat' do
  user '%tomcat'
  runas 'app_user'
  commands ['/etc/init.d/tomcat restart', '/etc/init.d/tomcat stop', '/etc/init.d/tomcat start']
  defaults ['!requiretty', 'env_reset']
end

sudo 'bob' do
  user 'bob'
end

sudo 'invalid.user' do
  user 'bob'
end

sudo 'alice' do
  user 'alice'
  command_aliases [{ name: 'STARTSSH', command_list: ['/etc/init.d/ssh start', '/etc/init.d/ssh restart', '! /etc/init.d/ssh stop'] }]
  commands ['STARTSSH']
end

sudo 'git' do
  user 'git'
  runas 'phabricator'
  nopasswd true
  setenv true
  commands ['/usr/bin/git-upload-pack', '/usr/bin/git-receive-pack']
end
