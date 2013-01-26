#!/bin/bash

test_app1_runs_on_port_80()
{
  curl http://localhost > /dev/null

  assertTrue "could not connect to port 80" $?
}

test_app1_root_page_contains_nginx_default_markup()
{
  curl http://localhost | grep "Welcome to nginx!" > /dev/null

  assertTrue "nginx markup was not found" $?
}

test_app2_runs_on_port_81()
{
  curl http://localhost:81 > /dev/null

  assertTrue "could not connect to port 81" $?
}

test_app2_root_page_contains_nginx_default_markup()
{
  curl http://localhost | grep "Welcome to nginx!" > /dev/null

  assertTrue "nginx markup was not found" $?
}
