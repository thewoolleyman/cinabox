#!/bin/bash
if [ -e /home/ci ]; then echo "ci user already exists.  To delete the ci user and start from scratch, type 'sudo deluser --remove-home ci'" && exit 1; fi

sudo aptitude install -y mkpasswd makepasswd # Ubuntu names it makepasswd, not mkpasswd
echo "  Creating ci user..."
if [ -z $CI_PASSWORD ]; then read -p "    Please type password for ci user and press enter:" -s -a CI_PASSWORD; fi
echo 
sudo useradd -s /bin/bash -m -p `mkpasswd -H md5 $CI_PASSWORD` ci

grep -q 'ci      ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
if [ ! $? = 0 ]; then  
  echo "  Giving ci user NO PASSWORD sudo privileges"
  sudo rm -f /tmp/sudoers.tmp
  sudo cp /etc/sudoers /etc/sudoers.bak
  sudo cp /etc/sudoers /tmp/sudoers.tmp
  sudo echo "ci      ALL=(ALL) NOPASSWD: ALL" >> /tmp/sudoers.tmp
  sudo visudo -q -c -s -f /tmp/sudoers.tmp
  if [ ! $? = 0 ]; then echo "error editing sudoers file" && exit; fi
  sudo cp /tmp/sudoers.tmp /etc/sudoers
fi