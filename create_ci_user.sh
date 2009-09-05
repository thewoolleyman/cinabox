#!/bin/bash

# TODO: this doesn't work on distros without deluser, e.g. Gentoo

if [ -e /home/ci ]; then 
  echo "ci user already exists.  Do you want to delete the and recreate the ci user from scratch with 'sudo deluser --remove-home ci'?  Type 'yes' or 'no':"
  read SHOULD_DELETE_CI_USER
  if [ "$SHOULD_DELETE_CI_USER" = 'yes' ]; then
    sudo deluser --remove-home ci
  else
    exit 1
  fi
fi

echo "  Creating ci user..."
echo 
sudo useradd -s /bin/bash -m ci
if [ ! -e /home/ci ]; then echo "ci user was not created successfully, aborting..." && exit 1; fi

echo "  Please assign a password for the ci user..."
echo 
sudo passwd ci
if [ ! $? = 0 ]; then echo "password assignment for CI user failed, aborting..." && exit 1; fi # Note that Ubuntu 8.10 returns zero even on passwd retype failure...

# Run ci_user_nopasswd_sudo.sh to give ci user no-password sudo authority