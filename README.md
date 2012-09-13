RubyGems-alt
=======================

A webhook simple reciever for RubyGems. For a long time I was checking out all new gems on twitter when goint to the geek cave every day, and life was all good. But then on september 1st 2012, the flow suddenly stopped ! Damn, something is broken. Ok, that will come back ... Well, on sept. 13th it was obvious that it won't come back that fast and then I missed my twitter feed too much so I wrote a new one.

It uses the excellent [Twitter](https://github.com/sferik/twitter) gem and the fabulous [Eventmachine](http://rubyeventmachine.com/) engine for the webhooks server. Urls are shortened with [Bitly gem](https://github.com/philnash/bitly).

Install
----------------

    git clone https://github.com/mose/rubygems-alt.git
    cd rubygems-alt
    cp config.defaults config
    vi config # and change config params
    bundle install

Launch
----------------

    ./rgt.sh

Daemonize
----------------

    to be done

Check out
-----------------

[@rubygemsalt](https://twitter.com/RubyGemsAlt) on twitter


Licence
------------------

MIT licence aplies to this tiny piece of code
Copyright 2012 Mose
