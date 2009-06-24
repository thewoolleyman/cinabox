#!/bin/bash
if [ -e /home/ci ]; then echo "ci user already exists.  To delete the ci user and start from scratch, type 'sudo deluser --remove-home ci'" && exit 1; fi

echo "  Creating ci user..."
echo 
sudo useradd -s /bin/bash -m ci
if [ ! -e /home/ci ]; then echo "ci user was not created successfully, aborting..." && exit 1; fi

echo "  Please assign a password for the ci user..."
echo 
sudo passwd ci
if [ ! $? = 0 ]; then echo "password assignment for CI user failed, aborting..." && exit 1; fi # Note that Ubuntu 8.10 returns zero even on passwd retype failure...

sudo grep -q 'ci      ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
if [ ! $? = 0 ]; then  
  echo "  Giving ci user NO PASSWORD sudo privileges"
  sudo rm -f /tmp/sudoers.tmp
  sudo cp /etc/sudoers /etc/sudoers.bak
  sudo cp /etc/sudoers /tmp/sudoers.tmp
  sudo sh -c 'echo "ci      ALL=(ALL) NOPASSWD: ALL" >> /tmp/sudoers.tmp'
  if [ ! -e /tmp/sudoers.tmp ]; then echo "/tmp/sudoers.tmp does not exist, aborting before we blow away all sudo access and completely hose this system..." && exit 1; fi
  sudo visudo -q -c -s -f /tmp/sudoers.tmp
  if [ ! $? = 0 ]; then echo "error editing sudoers file" && exit; fi
  sudo cp /tmp/sudoers.tmp /etc/sudoers
fi