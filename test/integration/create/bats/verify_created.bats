@test "it creates the tomcat user" {
  test -f /etc/sudoers.d/tomcat
}

@test "it gives sudo access for each command on it's own line (COOK-2119)" {
  sudo cat /etc/sudoers.d/tomcat | grep "%tomcat  ALL=(app_user) /etc/init.d/tomcat restart"
  sudo cat /etc/sudoers.d/tomcat | grep "%tomcat  ALL=(app_user) /etc/init.d/tomcat stop"
  sudo cat /etc/sudoers.d/tomcat | grep "%tomcat  ALL=(app_user) /etc/init.d/tomcat start"
}
