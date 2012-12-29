#!/usr/bin/env bats

@test "app1 is running on port 80" {
  curl http://localhost
}

@test "app1 root page contains the nginx default markup" {
  curl http://localhost | grep "Welcome to nginx!"
}

@test "app2 is running on port 81" {
  curl http://localhost:81
}

@test "app2 root page contains the nginx default markup" {
  curl http://localhost:81 | grep "Welcome to nginx!"
}
