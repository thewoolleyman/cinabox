#!/bin/bash
# A wrapper script to download and run bootstrap_ruby.sh, see http://github.com/thewoolleyman/bootstrap-ruby


wget -O /tmp/bootstrap_ruby.sh http://github.com/thewoolleyman/bootstrap-ruby/raw/master/bootstrap_ruby.sh
chmod a+x /tmp/bootstrap_ruby.sh
NO_RUBY_PROGRAM_SUFFIX=true /tmp/bootstrap_ruby.sh # Disable Ruby program suffix until Rubygems issues with non-default format-executables are resolved.
