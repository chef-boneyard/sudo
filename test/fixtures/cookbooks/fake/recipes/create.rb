include_recipe 'fake::default'

sudo 'tomcat' do
  user      '%tomcat'
  runas     'app_user'
  commands  ['/etc/init.d/tomcat restart', '/etc/init.d/tomcat stop', '/etc/init.d/tomcat start']
end
