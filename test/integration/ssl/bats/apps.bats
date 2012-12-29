#!/usr/bin/env bats

@test "app is running on HTTPS port 80" {
  curl https://localhost --cacert /etc/nginx/ssl/sslapp.cert
}

@test "app root page contains the nginx default markup" {
  curl https://localhost --cacert /etc/nginx/ssl/sslapp.cert | grep "Welcome to nginx!"
}
