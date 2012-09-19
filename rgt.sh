#!/bin/sh

if [ "$1" = "stop" ]; then
  if test -f 'tmp/rubygems-announce.pid' ; then
    cat tmp/rubygems-announce.pid | xargs kill
    echo "rgt killed."
  else
    echo "rgt not running."
  fi
else
  . ./config
  /usr/bin/env ruby ./lib/launch.rb
  echo "rgt launched."
fi

exit 0
