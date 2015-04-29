#!/bin/bash -e

echo `date` "Starting SSHD"
/usr/sbin/sshd -e

echo `date` "Running mongod repair"
/usr/bin/mongod --repair --config /etc/mongod.conf

echo `date` "Starting MongoDB"
/usr/bin/mongod --config /etc/mongod.conf --fork --smallfiles --nojournal

# Test for and execute a hook script (to be past by docker images layered
# on top of this image.
if [ -x /start-image-hook.sh ]
then
  echo `date` "Running start-image-hook"
  . /start-image-hook.sh
fi

echo `date` "Starting MEAN.IO Appserver"
su - mean -c "cd appserver && grunt cssmin && grunt uglify && NODE_ENV=production forever -w -c 'node ${NODEARGS}' server.js ${MEANARGS}"
