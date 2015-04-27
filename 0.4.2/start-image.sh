#!/bin/bash -e

echo `date` "Starting SSHD"
/usr/sbin/sshd -e

echo `date` "Starting MongoDB"
/usr/bin/mongod --config /etc/mongod.conf --fork

echo `date` "Starting MEAN.IO Appserver"
su - mean -c "cd appserver && NODE_ENV=production forever -w server.js"
