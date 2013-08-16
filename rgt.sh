#!/bin/sh

# ./rgt.sh      : starts server
# ./rgt.sh stop : stops server

if [ "$1" = "stop" ]; then
  if test -f 'tmp/rubygems-announce.pid' ; then
    cat tmp/rubygems-announce.pid | xargs -- kill -9
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
