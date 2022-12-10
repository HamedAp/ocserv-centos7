#!/usr/bin/expect -f

sudo chmod -R 755 /etc/ocserv/passwd

ocpasswd -c /etc/ocserv/passwd -g default $1  <<!
$2
$2
!


