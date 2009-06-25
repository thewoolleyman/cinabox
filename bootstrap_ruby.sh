#!/bin/bash
# This script is tested on Ubuntu Linux, but it should run on most Debian distros

# Install build prerequisites
sudo aptitude update
sudo aptitude install -y build-essential
sudo aptitude install -y zlib1g zlib1g-dev
sudo aptitude install -y libssl-dev openssl
sudo aptitude install -y libreadline5-dev
sudo aptitude install -y openssh-server openssh-client
sudo aptitude install -y wget

# Set default options with allowed overrides
DEFAULT_RUBY_VERSION=1.8.6-p287
if [ -z $RUBY_VERSION ]; then RUBY_VERSION=$DEFAULT_RUBY_VERSION; fi
RUBY_MINOR_VERSION=${RUBY_VERSION:0:3}
RUBY_TEENY_VERSION=${RUBY_VERSION:0:5}
if [ -z $RUBY_PREFIX ]; then RUBY_PREFIX=/usr/local/lib/ruby$RUBY_TEENY_VERSION; fi
if [ -z $RUBY_PROGRAM_SUFFIX ]; then RUBY_PROGRAM_SUFFIX=$RUBY_TEENY_VERSION; fi
if [ -z $BUILD_DIR ]; then export BUILD_DIR=~/.cinabox; fi

# Remove existing Debian ruby installation (commented for now, this could screw up existing systems)
# sudo aptitude remove -y ruby ruby1.8 libruby1.8

# Download and unpack Ruby distribution
mkdir -p $BUILD_DIR
cd $BUILD_DIR
rm -rf ruby-$RUBY_VERSION.tar.gz
wget ftp://ftp.ruby-lang.org/pub/ruby/$RUBY_MINOR_VERSION/ruby-$RUBY_VERSION.tar.gz
rm -rf ruby-$RUBY_VERSION
tar -zxvf ruby-$RUBY_VERSION.tar.gz

# Update extensions Setup by deleting “Win” lines (Win32API and win32ole) and uncommenting all other lines
if [ ! -e ruby-$RUBY_VERSION/ext/Setup.orig ]; then cp ruby-$RUBY_VERSION/ext/Setup ruby-$RUBY_VERSION/ext/Setup.orig; fi
cat ruby-$RUBY_VERSION/ext/Setup.orig | grep -iv 'win' | grep -iv 'nodynamic' | sed -n -e 's/#\(.*\)/\1/p' > /tmp/Setup.new
cp /tmp/Setup.new ruby-$RUBY_VERSION/ext/Setup

# Configure, make, and install
cd $BUILD_DIR/ruby-$RUBY_VERSION

# Apply patch required for Ruby 1.8.7-p72 - see http://redmine.ruby-lang.org/issues/show/863
if [ $RUBY_VERSION = '1.8.7-p72' ]; then 
  cat ext/openssl/ossl_digest.c | grep -v 'rb_require("openssl")' > ext/openssl/ossl_digest.c.patched
  cp ext/openssl/ossl_digest.c.patched ext/openssl/ossl_digest.c
fi

if [ $RUBY_MINOR_VERSION = 1.8 ]; then VERSION_OPTS=--disable-pthreads; else VERSION_OPTS=; fi
./configure $VERSION_OPTS --prefix=$RUBY_PREFIX --program-suffix=$RUBY_PROGRAM_SUFFIX
make
if [ ! $? = 0 ]; then echo "error running 'make'" && exit 1; fi
rm -rf .ext/rdoc
sudo make install
if [ ! $? = 0 ]; then echo "error running 'sudo make install'" && exit 1; fi

# Download and install RubyGems
if [ -z $RUBYGEMS_MIRROR_ID ]; then RUBYGEMS_MIRROR_ID=57643; fi
if [ -z $RUBYGEMS_VERSION ]; then RUBYGEMS_VERSION=1.3.4; fi
cd $BUILD_DIR
rm -rf rubygems-$RUBYGEMS_VERSION.tgz
wget http://rubyforge.org/frs/download.php/$RUBYGEMS_MIRROR_ID/rubygems-$RUBYGEMS_VERSION.tgz
rm -rf rubygems-$RUBYGEMS_VERSION
tar -zxvf rubygems-$RUBYGEMS_VERSION.tgz
cd $BUILD_DIR/rubygems-$RUBYGEMS_VERSION
sudo $RUBY_PREFIX/bin/ruby$RUBY_PROGRAM_SUFFIX setup.rb
if [ ! $? = 0 ]; then echo "error building rubygems" && exit 1; fi

# Make symlinks for all executables
sudo ln -sf `cd $RUBY_PREFIX && pwd`/bin/* /usr/local/bin

# Set up alternatives entry
# To pick from multiple rubies interactively, use 'sudo update-alternatives --config ruby'
sudo update-alternatives --install \
 /usr/local/bin/ruby ruby $RUBY_PREFIX/bin/ruby$RUBY_PROGRAM_SUFFIX 100 \
 --slave /usr/local/bin/erb erb $RUBY_PREFIX/bin/erb$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/gem gem $RUBY_PREFIX/bin/gem$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/irb irb $RUBY_PREFIX/bin/irb$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/rdoc rdoc $RUBY_PREFIX/bin/rdoc$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/ri ri $RUBY_PREFIX/bin/ri$RUBY_PROGRAM_SUFFIX \
 --slave /usr/local/bin/testrb testrb $RUBY_PREFIX/bin/testrb$RUBY_PROGRAM_SUFFIX
