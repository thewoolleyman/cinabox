# This script is tested on Ubuntu Linux, but it should run on most Debian distros

sudo aptitude update
sudo aptitude install -y build-essential
sudo aptitude install -y zlib1g zlib1g-dev
sudo aptitude install -y libssl-dev openssl
sudo aptitude install -y openssh-server openssh-client
sudo aptitude install -y wget

DEFAULT_RUBY_VERSION=1.8.6-p287
if [ -z $RUBY_VERSION ]; then RUBY_VERSION=$DEFAULT_RUBY_VERSION; fi
RUBY_MINOR_VERSION=${RUBY_VERSION:0:3}
RUBY_TEENY_VERSION=${RUBY_VERSION:0:5}
if [ -z $RUBY_PREFIX ]; then RUBY_PREFIX=/usr/local/lib/ruby$RUBY_TEENY_VERSION; fi
if [ -z $RUBY_PROGRAM_SUFFIX ]; then RUBY_PROGRAM_SUFFIX=$RUBY_TEENY_VERSION; fi

if [ -z $BUILD_DIR ]; then export BUILD_DIR=~/.cinabox; fi

mkdir -p $BUILD_DIR
cd $BUILD_DIR

rm -rf $BUILD_DIR/ruby-$RUBY_VERSION.tar.gz
wget ftp://ftp.ruby-lang.org/pub/ruby/$RUBY_MINOR_VERSION/ruby-$RUBY_VERSION.tar.gz
rm -rf $BUILD_DIR/ruby-$RUBY_VERSION
tar -zxvf ruby-$RUBY_VERSION.tar.gz

# delete “Win” lines (Win32API and win32ole) and uncomment all other lines
if [ ! -e ruby-$RUBY_VERSION/ext/Setup.orig ]; then cp ruby-$RUBY_VERSION/ext/Setup ruby-$RUBY_VERSION/ext/Setup.orig; fi
cat ruby-$RUBY_VERSION/ext/Setup.orig | grep -iv 'win' | sed -n -e 's/#\(.*\)/\1/p' > /tmp/Setup.new
cp /tmp/Setup.new ruby-$RUBY_VERSION/ext/Setup

cd $BUILD_DIR/ruby-$RUBY_VERSION

./configure --disable-pthreads --prefix=$RUBY_PREFIX --program-suffix=$RUBY_PROGRAM_SUFFIX
make
sudo make install

# make symlinks for all executables
sudo ln -s `cd $RUBY_PREFIX && pwd`/* /usr/local/bin