# This script is designed to run on a standard Ubuntu Linux 7.04 Desktop install

sudo apt-get update
p 'installing zlib...'
sudo apt-get install -y zlib1g zlib1g-dev
p 'installing ssl...'
sudo apt-get install -y libssl-dev openssl

export BUILD_DIR=~/build
mkdir $BUILD_DIR
cd $BUILD_DIR

rm -rf $BUILD_DIR/ruby-1.8.5.tar

wget ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.5.tar.gz
tar -zxvf ruby-1.8.5.tar.gz

# remove and uncomment all “non-Win” lines (all except
# Win32API and win32ole)
cp ruby-1.8.5/ext/Setup ruby-1.8.5/ext/Setup.orig
cat ruby-1.8.5/ext/Setup.orig | grep -iv 'win' | sed -n -e 's/#\(.*\)/\1/p' > /tmp/Setup.new
cp /tmp/Setup.new ruby-1.8.5/ext/Setup

cd $BUILD_DIR/ruby-1.8.5

./configure
make
sudo make install

