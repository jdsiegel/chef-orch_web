#!/usr/bin/env bats

@test "creates nginx directory" {
  [ -d "/etc/nginx" ]
}
