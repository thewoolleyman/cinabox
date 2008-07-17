# This script is designed to run on a standard Ubuntu Linux Desktop install

sudo aptitude update
p 'installing zlib...'
sudo aptitude install -y zlib1g zlib1g-dev
p 'installing ssl...'
sudo aptitude install -y libssl-dev openssl

export RUBY_VERSION=1.8.6-p230
export BUILD_DIR=~/build
mkdir $BUILD_DIR
cd $BUILD_DIR

rm -rf $BUILD_DIR/ruby-$RUBY_VERSION.tar.gz

wget ftp://ftp.ruby-lang.org/pub/ruby/ruby-$RUBY_VERSION.tar.gz
tar -zxvf ruby-$RUBY_VERSION.tar.gz

# remove and uncomment all “non-Win” lines (all except
# Win32API and win32ole)
cp ruby-$RUBY_VERSION/ext/Setup ruby-$RUBY_VERSION/ext/Setup.orig
cat ruby-$RUBY_VERSION/ext/Setup.orig | grep -iv 'win' | sed -n -e 's/#\(.*\)/\1/p' > /tmp/Setup.new
cp /tmp/Setup.new ruby-$RUBY_VERSION/ext/Setup

cd $BUILD_DIR/ruby-$RUBY_VERSION

./configure
make
sudo make install

