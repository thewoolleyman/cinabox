#!/bin/bash
RUBY_PREFIX=/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr
RUBY_PROGRAM_SUFFIX=
sudo update-alternatives --install \
 /usr/local/bin/ruby ruby $RUBY_PREFIX/bin/ruby$RUBY_PROGRAM_SUFFIX 100 \
 --slave /usr/local/bin/erb erb $RUBY_PREFIX/bin/erb$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/gem gem $RUBY_PREFIX/bin/gem$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/irb irb $RUBY_PREFIX/bin/irb$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/rdoc rdoc $RUBY_PREFIX/bin/rdoc$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/ri ri $RUBY_PREFIX/bin/ri$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/testrb testrb $RUBY_PREFIX/bin/testrb$RUBY_PROGRAM_SUFFIX