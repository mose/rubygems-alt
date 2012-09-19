rubygems-announce
=======================

A webhook simple reciever for RubyGems.

For a long time I was checking out
all new gems on twitter when going to the geek cave every day, and life was
all good. But then on september 1st 2012, the flow suddenly stopped !
Damn, something is broken. Ok, that will come back ... Well, on sept. 13th
it was obvious that it won't come back that fast and then I missed my
twitter feed too much so I wrote a new one.

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

Daemonized
----------------

The rubygems-announce process will be launched in the background, and you can find its logs in logs/rubygems-announce.output

Check out
-----------------

[@rubygemsalt](https://twitter.com/RubyGemsAlt) on twitter


Licence
------------------

(The MIT License)

Copyright (c) Mose, at mose.fr

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

