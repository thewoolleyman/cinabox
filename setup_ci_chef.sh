#!/bin/bash

# use bootstrap-ruby to install ruby.  See http://github.com/thewoolleyman/bootstrap-ruby
wget -O /tmp/bootstrap_ruby.sh http://github.com/thewoolleyman/bootstrap-ruby/raw/master/bootstrap_ruby.sh
chmod a+x /tmp/bootstrap_ruby.sh
/tmp/bootstrap_ruby.sh

# install chef
sudo gem install ohai chef --source=http://gems.opscode.com --source=http://gems.rubyforge.org



