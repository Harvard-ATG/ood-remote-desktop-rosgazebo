#!/bin/bash

echo 'Updating /etc/hosts file...'
HOSTNAME=$(hostname)
echo "127.0.1.1\t$HOSTNAME" >> /etc/hosts
/usr/bin/vncserver -kill :1 || true
/usr/bin/vncserver -geometry 1024x768
tail -f /root/.vnc/*:1.log
