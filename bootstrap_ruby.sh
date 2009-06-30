#!/bin/bash
# A wrapper script to download and run bootstrap_ruby.sh, see http://github.com/thewoolleyman/bootstrap-ruby


wget -O /tmp/bootstrap_ruby.sh http://github.com/thewoolleyman/bootstrap-ruby/raw/master/bootstrap_ruby.sh
chmod a+x /tmp/bootstrap_ruby.sh
/tmp/bootstrap_ruby.sh
