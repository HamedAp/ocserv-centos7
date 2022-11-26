yum install epel-release -y > /dev/null &
yum update -y > /dev/null &
yum install ocserv gnutls-utils -y > /dev/null &
mkdir /etc/ocserv/cert
cd /etc/ocserv/cert/

cat <<EOT >> ca.tmpl
cn = "VPN CA"
organization = "Big Corp"
serial = 1
expiration_days = -1
ca
signing_key
cert_signing_key
crl_signing_key
EOT

certtool --generate-privkey --outfile ca-key.pem
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem

cat <<EOT >> /etc/ocserv/server.tmpl
cn = "My server"
dns_name = "www.example.com"
organization = "MyCompany"
expiration_days = -1
signing_key
encryption_key
tls_www_server
EOT

certtool --generate-privkey --outfile server-key.pem
certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template /etc/ocserv/server.tmpl --outfile server-cert.pem

mkdir /etc/ocserv/ssl/
cp ca-cert.pem server-key.pem server-cert.pem /etc/ocserv/ssl/

cd /etc/ocserv/
wget -N https://raw.githubusercontent.com/hamedap/ocserv-centos7/main/ocserv.conf
touch /etc/ocserv/passwd

yum install iptables-services -y > /dev/null &
wait

iptables -I INPUT -p tcp --dport 5829 -j ACCEPT & # SSH port
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -j ACCEPT
iptables -A FORWARD -j REJECT
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o venet0 -j MASQUERADE
iptables -I INPUT -p tcp --dport 4431 -j ACCEPT &
iptables -I INPUT -p udp --dport 4431 -j ACCEPT &
iptables -I INPUT -p udp --dport 53 -j ACCEPT &
iptables -t nat -A POSTROUTING -j MASQUERADE &


echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf &
systemctl restart ocserv
systemctl enable ocserv
echo "Finished ! :) Have Fun "
ocpasswd -c /etc/ocserv/passwd -g default hamed
