@test "it creates the sudoers.d directory" {
  test -d /etc/sudoers.d
}

@test "it drops the README" {
  sudo cat /etc/sudoers.d/README | grep "As of Debian version"
}

@test "it creates the /etc/sudoers" {
  test -f /etc/sudoers
}
