#!/bin/bash

test_app_is_running_on_https()
{
  curl https://localhost --cacert /etc/nginx/ssl/sslapp.cert > /dev/null

  assertTrue "could not connect to https port" $?
}

test_app_root_page_contains_nginx_default_markup()
{
  curl https://localhost --cacert /etc/nginx/ssl/sslapp.cert | grep "Welcome to nginx!" > /dev/null

  assertTrue "nginx markup was not found" $?
}
