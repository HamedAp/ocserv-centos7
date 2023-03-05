yum install epel-release -y &
wait

yum update -y  &
wait


yum install httpd php ocserv gnutls-utils -y &
wait

rm -fr /etc/ocserv/cert &
wait

mkdir /etc/ocserv/cert &
wait


rm -fr /etc/ocserv/cert/ca.tmpl
cat <<EOT >> /etc/ocserv/cert/ca.tmpl
cn = "VPN CA"
organization = "Big Corp"
serial = 1
expiration_days = -1
ca
signing_key
cert_signing_key
crl_signing_key
EOT


rm -fr ca-key.pem ca-cert.pem &
wait

certtool --generate-privkey --outfile ca-key.pem &
wait

certtool --generate-self-signed --load-privkey ca-key.pem --template /etc/ocserv/cert/ca.tmpl --outfile ca-cert.pem &
wait

rm -fr /etc/ocserv/server.tmpl &
wait

cat <<EOT >> /etc/ocserv/server.tmpl 
cn = "My server"
dns_name = "www.example.com"
organization = "MyCompany"
expiration_days = -1
signing_key
encryption_key
tls_www_server
EOT

rm -fr server-key.pem server-key.pem &
wait

certtool --generate-privkey --outfile server-key.pem &
wait

certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template /etc/ocserv/server.tmpl --outfile server-cert.pem &
wait

rm -fr /etc/ocserv/ssl/ &
wait

mkdir /etc/ocserv/ssl/ &
wait

cp ca-cert.pem server-key.pem server-cert.pem /etc/ocserv/ssl/ &
wait 

wget -N https://raw.githubusercontent.com/hamedap/ocserv-centos7/main/ocserv.conf -O /etc/ocserv/ocserv.conf &
wait

wget -N https://raw.githubusercontent.com/hamedap/ocserv-centos7/main/addcisco.sh -O /root/adduser.sh &
wait

touch /etc/ocserv/passwd &
wait

iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT &
wait
iptables -A FORWARD -s 192.168.1.0/24 -j ACCEPT &
wait
iptables -A FORWARD -j REJECT &
wait
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o venet0 -j MASQUERADE &
wait

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf &
wait
systemctl restart ocserv &
wait
systemctl enable ocserv &
wait
systemctl restart httpd &
wait
systemctl enable httpd &
wait
sudo chmod -R 755 /etc/ocserv/ &
wait
clear
echo "Finished ! :) Have Fun "

