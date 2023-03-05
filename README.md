# ocserv-centos7
 Panel have permission problem . ( fix soon )


````
bash <(curl -Ls https://raw.githubusercontent.com/HamedAp/ocserv-centos7/master/install.sh)
````

Change ````venet0```` to your network interface in ( install.sh - Line 93) 


# Add user

````
ocpasswd -c /etc/ocserv/passwd -g default test
````
