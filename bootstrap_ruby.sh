#!/bin/bash
# A wrapper script to download and run bootstrap_ruby.sh, see http://github.com/thewoolleyman/bootstrap-ruby

  
if [ -z $BOOTSTRAP_RUBY_GIT_DOWNLOAD_URL ]; then BOOTSTRAP_RUBY_GIT_DOWNLOAD_URL='http://github.com/thewoolleyman/bootstrap-ruby/raw/master'; fi

sudo rm -f /tmp/bootstrap_ruby.sh
wget -O /tmp/bootstrap_ruby.sh $BOOTSTRAP_RUBY_GIT_DOWNLOAD_URL/bootstrap_ruby.sh
chmod a+x /tmp/bootstrap_ruby.sh
NO_RUBY_PROGRAM_SUFFIX=true /tmp/bootstrap_ruby.sh # Disable Ruby program suffix until Rubygems issues with non-default format-executables are resolved.
