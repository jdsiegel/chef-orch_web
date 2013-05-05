#!/bin/bash

test_app_is_running_on_https()
{
  curl -s https://localhost --cacert /etc/nginx/ssl/sslapp.cert > /dev/null

  assertTrue "could not connect to https port" $?
}

test_app_root_page_contains_nginx_default_markup()
{
  curl -s https://localhost --cacert /etc/nginx/ssl/sslapp.cert | grep "Welcome to nginx!" > /dev/null

  assertTrue "nginx markup was not found" $?
}

test_app_serves_static_files_from_root_path()
{
  local output=$(curl -s https://localhost/notes.txt --cacert /etc/nginx/ssl/sslapp.cert)

  assertEquals "This should be served up" "$output"
}
