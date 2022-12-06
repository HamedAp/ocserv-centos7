#!/usr/bin/expect -f



ocpasswd -c /etc/ocserv/passwd -g default $1  <<!
$2
$2
!

sudo chmod -R 755 /etc/ocserv/
