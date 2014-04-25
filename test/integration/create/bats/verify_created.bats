@test "it creates the tomcat and bob users" {
  test -f /etc/sudoers.d/tomcat
  test -f /etc/sudoers.d/bob
}

@test "it gives sudo access for each command on it's own line (COOK-2119)" {
  sudo cat /etc/sudoers.d/tomcat | grep "%tomcat  ALL=(app_user) /etc/init.d/tomcat restart"
  sudo cat /etc/sudoers.d/tomcat | grep "%tomcat  ALL=(app_user) /etc/init.d/tomcat stop"
  sudo cat /etc/sudoers.d/tomcat | grep "%tomcat  ALL=(app_user) /etc/init.d/tomcat start"
}

@test "it sets sudo defaults for specific sudo resources (COOK-3409)" {
  sudo cat /etc/sudoers.d/tomcat | egrep "^Defaults:%tomcat \!requiretty,env_reset"
}

@test "it doesn't create defaults for specific sudo resource if no defaults are set (COOK-3409)" {
  sudo cat /etc/sudoers.d/bob | egrep -v "^Defaults:bob"
}

@test "it supports providing command aliases for sudo usage (COOK-4612)" {
  sudo grep -E "^Cmnd_Alias STARTSSH = /etc/init.d/ssh start, /etc/init.d/ssh restart, \! /etc/init.d/ssh stop$" /etc/sudoers.d/alice
  sudo grep -E "^alice  ALL=\(ALL\) STARTSSH$" /etc/sudoers.d/alice
}
